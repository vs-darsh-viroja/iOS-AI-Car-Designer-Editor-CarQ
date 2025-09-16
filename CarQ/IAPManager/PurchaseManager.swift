//
//  PurchaseManager.swift
//  CarQ
//
//  Created by Purvi Sancheti on 16/09/25.
//



import Foundation
import StoreKit
import WidgetKit

@MainActor
class PurchaseManager: NSObject, ObservableObject {
    @Published var products: [Product] = []
    
    @Published var productIds: [String] = SubscriptionPlan.productIDs.values.map { $0 }
    
    @Published var userSettings = UserSettings()
    @Published private(set) var purchasedProductIDs = Set<String>()
    @Published var hasPro: Bool = false {
        didSet {
            userSettings.isPaid = hasPro
        }
    }
    
    @Published var isInProgress = true
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private var productLoaded = false
    private var updates: Task<Void, Never>? = nil

    override init() {
        super.init()
        
        self.updates =  observeTransactionUpdates()
        
        Task {
            //Fetch products
            await self.fetchProducts()
            
            await self.updatePurchaseProducts()
        }
        
        //  Observe App Foreground Events
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        
    }
    
    deinit {
        self.updates?.cancel()
    }
    
    @objc func appDidBecomeActive() {
           Task {
               await updatePurchaseProducts()
           }
       }
    
    @MainActor
    func fetchProducts() async {
        guard !self.productLoaded else {
            print("Product already loaded.")
            return
        }
        self.isInProgress = true
        
        do {
            self.products = try await Product.products(for: productIds)
            self.productLoaded = true
        } catch {
            print("Failed to load products with error: \(error)")
        }
    }
    
    func purchase(_ product: Product) async throws {
        self.isInProgress = true
        let result = try await product.purchase()
        
        if purchasedProductIDs.contains(product.id) {
            self.showAlert = true
            self.alertMessage = "You've already purchased this plan"
            self.isInProgress = false
            userSettings.isPaid = true
        } else {
            switch result {
            case let .success(.verified(transaction)):
                print(transaction)
                
                // Successful purchase
                await transaction.finish()
                
                userSettings.isPaid = true
                
                if let plan = SubscriptionPlan.plan(for: transaction.productID) {
                    userSettings.planType = plan.planName
                }
                print("Calling updatePurchaseProducts() after successful purchase")
                
                await self.updatePurchaseProducts()
            
            case .success(.unverified(_, _)):
                // Successful purchase but transaction/receipt can't be verified
                // Could be a jailbroken phone
                self.alertMessage = "Transaction/receipt can't be verified, phone might be jailbroken!"
                self.isInProgress = false
                break

            
            case .userCancelled:
                self.hasPro = false
                userSettings.isPaid = false
                self.isInProgress = false
                break
            case .pending:
                // Transaction waiting on SCA (Strong Customer Authentication) or
                // approval from Ask to Buy
                self.alertMessage = "Transaction waiting on Strong Customer Authentication!"
                self.isInProgress = false
                break
            @unknown default:
                self.hasPro = false
                userSettings.isPaid = false
                self.isInProgress = false
                break
            }
        }
    }
    
    @MainActor
    func updatePurchaseProducts(isRestore: Bool = false) async {
        self.isInProgress = true
                        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                print("Unverified transaction found")
                continue
            }
            print("Verified transaction found: \(transaction.productID)")

            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
                updatePlanType(for: transaction.productID)
            } else {
                self.showAlert = true
                self.alertMessage = "Your subscription has been cancelled or expired."
                self.purchasedProductIDs.remove(transaction.productID)
            }
            
            if isRestore {
                // Fetch the set of product IDs from transactions
                
                // Fetch product information
                
                do {
                    let products = try await Product.products(for: [transaction.productID])
                    
                    let productInfo = Dictionary(uniqueKeysWithValues: products.map {
                        ($0.id, $0)
                    })
                } catch {
                    print(error)
                }
            }
        }
        if isRestore && self.purchasedProductIDs.isEmpty {
            self.showAlert = true
            self.alertMessage = "Subscription does not exist!"
        }
        
        self.hasPro = !self.purchasedProductIDs.isEmpty
        userSettings.isPaid = !self.purchasedProductIDs.isEmpty
        self.isInProgress = false
        
        UserDefaults(suiteName: "group.com.quotes.Stoicism")?.set(hasPro, forKey: "isProUser")

        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func updatePlanType(for productID: String) {
        if let plan = SubscriptionPlan.plan(for: productID) {
            userSettings.planType = plan.planName
            userSettings.isPaid = true
        }
    }
    
    func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await self.updatePurchaseProducts()
            }
        }
    }
}

enum SubscriptionPlan: String, CaseIterable {
    case weekly
    case yearly
    case yearlygift
    
    // Add new product IDs here as new cases:
    // case monthly = "com.zyric.monthly"


    static let productIDs: [SubscriptionPlan: String] = [
        .weekly: "com.carq.weekly",
        .yearly: "com.carq.yearly",
        .yearlygift: "com.carq.yearlygift",

    ]
    
    static func plan(for productId: String) -> SubscriptionPlan? {
        return productIDs.first(where: { $0.value == productId })?.key
    }
    

    var planName: String {
        switch self {
        case .weekly: return "Weekly"
        case .yearly: return "Yearly"
        case .yearlygift: return "Yearly Gift"
        }
    }

    var productId: String {
        return SubscriptionPlan.productIDs[self] ?? ""
    }
}

enum PremiumFeature: CaseIterable {
    case first
    case second
    case third
    case fourth

    
    var title: String {
        switch self {
        case .first:
            "Access every AI tool"
        case .second:
            "HD Quality Output"
        case .third:
            "No Watermarks"
        case .fourth:
            "Private & Secure"
        }
    }
    
    var image: ImageResource {
        switch self {
        case .first:
                .toolsIcon
        case .second:
                .hdIcon
        case .third:
                .watermarkIcon
        case .fourth:
                .securityIcon
        }
    }
    

}



struct PlanDetails: Codable {
    let planName: String
 
    init(planName: String) {
           self.planName = planName
 
       }
}



