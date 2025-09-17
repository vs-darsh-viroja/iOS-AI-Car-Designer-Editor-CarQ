import Foundation

struct CreatePrompts {
    static let all: [String] = [
        "futuristic cyberpunk sports car, metallicA purple body with glowing neon underglow and alloy wheels, parked in a rainy neon-lit Tokyo street, cinematic 4K render.",
        "A retro 1970s muscle car with flame decals, matte orange finish, wide custom exhaust pipes and rear spoiler, photographed on an empty desert highway at sunset, cinematic 4K detail.",
        "A luxury limousine with champagne gold paint, chrome grille, custom alloy wheels and roof rack, parked in front of a glass skyscraper at dusk, 4K ultra photoreal render.",
        "A stealth-inspired matte black coupe with sharp side skirts, tinted windows and carbon fiber spoiler, spotlighted in a grey futuristic studio, cinematic 4K realism.",
        "An off-road SUV with matte army green paint, roof rack, bull bar and oversized wheels, climbing rocky terrain in a misty mountain landscape, cinematic 4K detail.",
        "A low rider with metallic purple body, chrome wheels, neon lights beneath the chassis, custom decals on the sides, parked under glowing streetlights in an urban night scene, cinematic 4K render.",
        "A futuristic racing car with silver chrome body, glowing cyan racing stripes, large rear spoiler and diffuser, hovering above a digital racetrack grid, cinematic sci-fi 4K render.",
        "A retro classic convertible in pastel turquoise, chrome bumpers, white racing stripes and alloy wheels, photographed on a sunny palm-lined boulevard, cinematic nostalgic 4K render.",
        "A Japanese street racer with glossy red paint, bold anime-inspired decals, neon underglow and oversized spoiler, drifting on a wet city street at night, cinematic 4K HDR.",
        "A concept luxury EV with glass canopy roof, satin silver finish, carbon fiber side skirts and futuristic alloy wheels, showcased in a futuristic expo hall, cinematic 4K photoreal render.",
        "A muscular matte black Dodge-style coupe with widebody kit, custom exhausts and red neon glow, parked in an urban warehouse setting, cinematic 4K ultra detail.",
        "A futuristic hovercar with glowing blue accents, chrome finish, dual spoilers and underbody neon, floating above a neon cyberpunk skyline, cinematic sci-fi 4K realism.",
        "A luxury SUV with pearl white paint, gold trim, roof rack and diamond-cut alloy wheels, parked in front of a luxury resort entrance, cinematic 4K render.",
        "A retro low rider with teal paint, chrome detailing, hydraulic suspension and flame decals, cruising down a palm-lined street at golden hour, cinematic 4K photoreal render.",
        "A sporty coupe in glossy yellow with dual racing stripes, rear spoiler and carbon fiber side skirts, drifting on a racetrack with motion blur, cinematic 4K HDR.",
        "A futuristic concept minivan with glowing side panels, gradient paint finish and alloy wheels, parked in a high-tech exhibition hall, cinematic 4K detail.",
        "A Japanese tuner car in metallic blue, anime-style decals, widebody kit and neon pink underglow, drifting under highway bridges at night, cinematic 4K realism.",
        "A retro muscle car in deep red with chrome bumpers, hood scoop, white racing stripes and exhaust flames, parked at a 1970s diner, cinematic nostalgic 4K render.",
        "A futuristic stealth car in matte graphite finish, angular design with hidden spoiler and glowing red accents, showcased in a sci-fi grey studio, cinematic 4K realism.",
        "An off-road rally car in matte orange with roof rack, spare tires, mud decals and bull bar, tearing through a desert trail, cinematic 4K HDR.",
        "A luxury concept coupe in rose gold, satin finish, custom alloy wheels and illuminated side skirts, parked in front of a futuristic glass tower, cinematic 4K render.",
        "A cyberpunk-inspired hatchback with neon purple glow, bold decals, oversized spoiler and holographic windshield, parked in a rainy back alley, cinematic 4K detail.",
        "A retro convertible in pastel pink with chrome bumpers, whitewall tires and flame decals, parked at a drive-in theater, cinematic nostalgic 4K realism.",
        "A futuristic sports car in metallic cyan, glowing dual-tone finish, carbon fiber spoiler and neon rims, parked on a neon-lit bridge, cinematic 4K sci-fi render.",
        "A Japanese drift car in matte black with bold kanji decals, side skirts, neon blue underglow and racing exhaust, drifting on a mountain pass at night, cinematic 4K HDR.",
        "A luxury electric sedan in emerald green with chrome detailing, diamond-cut alloy wheels and panoramic roof, showcased in an upscale showroom, cinematic 4K photoreal render.",
        "A low rider in metallic gold with custom decals, chrome wheels, underbody neon lights and roof-mounted antennas, parked on a city street at night, cinematic 4K detail.",
        "A futuristic armored SUV in steel grey with glowing orange trims, roof rack and bull bars, standing in a dystopian cityscape, cinematic 4K ultra realism.",
        "A sporty track car in glossy red with white racing stripes, rear diffuser, carbon fiber spoiler and racing decals, photographed on a pit lane, cinematic 4K HDR.",
        "A retro futuristic bubble car with chrome fins, pastel yellow paint, glowing neon accents and alloy wheels, parked in a sci-fi retro diner, cinematic 4K surreal render."
    ]
}

struct MagicalModificationPrompts {
    static let all: [String] = [
        "​​Change the hood to carbon fiber",
        "Resize the wheels to be larger",
        "Add a roof rack on top",
        "Change the doors to glossy red",
        "Reshape the headlights to be slimmer",
        "Add racing stripes across the hood and roof",
        "Change the trunk to include a rear spoiler",
        "Make the exhaust pipes larger and chrome",
        "Reshape the side skirts to be sportier",
        "Change the mirrors to carbon fiber finish",
        "Add neon underglow lighting",
        "Resize the windows to be more narrow",
        "Change the roof to a panoramic glass design",
        "Add decals on the doors",
        "Make the front bumper more aggressive",
        "Change the wheels to alloy multi-spoke design",
        "Add a bull bar to the front",
        "Reshape the grille with a honeycomb pattern",
        "Make the side panels matte black",
        "Add a sunroof on top",
        "Change the rear lights to futuristic LED strips",
        "Add chrome trim around the windows",
        "Make the hood glossy white",
        "Reshape the rear bumper with diffuser",
        "Add widebody fenders",
        "Change the roof to satin black",
        "Add tinted windows",
        "Resize the spoiler to be larger",
        "Make the doors metallic blue",
        "Add carbon fiber side skirts"
    ]
}


struct ModifyObjectPrompts {
    static let all: [String] = [
        "Match the body color and finish to the reference car",
        "Apply the same wheel design as the reference car",
        "Transform the headlights to look like the reference image",
        "Make the body shape closer to the reference car",
        "Add decals and styling similar to the reference image",
        "Change the hood to carbon fiber",
        "Replace the wheels with glossy black alloy rims",
        "Add a large rear spoiler",
        "Turn the doors into scissor-style doors",
        "Change the paint to metallic blue with white racing stripes"
    ]
}



struct AddObjectPrompts {
    static let all: [String] = [
        "Add a roof rack on top",
        "Add a large rear spoiler",
        "Add custom alloy wheels",
        "Add a carbon fiber hood",
        "Add neon underglow lights",
        "Add racing decals on the sides",
        "Add a front bull bar",
        "Add a roof-mounted LED light bar",
        "Add a panoramic glass roof",
        "Add a widebody kit",
        "Add a side exhaust pipe",
        "Add tinted windows",
        "Add chrome trim around the doors",
        "Add roof cargo box",
        "Add rear diffuser",
        "Add scissor doors",
        "Add hood scoop",
        "Add rally fog lights",
        "Add carbon fiber side skirts",
        "Add futuristic glowing rims"
    ]
}

struct ReplaceObjectPrompts {
    static let all: [String] = [
        "Replace the wheels with custom alloy rims",
        "Replace the hood with a carbon fiber hood",
        "Replace the rear spoiler with a larger racing spoiler",
        "Replace the headlights with futuristic LED strips",
        "Replace the exhaust with dual chrome exhausts",
        "Replace the side mirrors with carbon fiber mirrors",
        "Replace the roof with a panoramic glass roof",
        "Replace the front bumper with a sporty aggressive bumper",
        "Replace the grille with a honeycomb grille",
        "Replace the doors with scissor doors",
        "Replace the paint with glossy metallic red",
        "Replace the side skirts with carbon fiber side skirts",
        "Replace the taillights with neon bar lights",
        "Replace the tires with off-road rugged tires",
        "Replace the rear bumper with a diffuser design",
        "Replace the decals with bold racing stripes",
        "Replace the alloy wheels with chrome rims",
        "Replace the headlights with classic round headlights",
        "Replace the hood with a matte black hood",
        "Replace the roof with a roof rack"
    ]
}


struct MinimalPrompts {
    static let all: [String] = [
        "A sleek minimal electric sedan, pure white body, soft reflections, studio lighting, ultra-clean aesthetic, 4K cinematic render.",
        "A minimal concept SUV, matte silver finish, panoramic glass roof, placed in a futuristic showroom, hyper-detailed, 4K photorealism.",
        "A minimal coupe, metallic gray, smooth flowing lines, dramatic spotlight from above, cinematic shadows, 4K ultra realism.",
        "A minimal hatchback, pastel green paint, sharp LED lights, showcased in a bright white gallery, high-resolution render, perfect clarity.",
        "A minimal roadster, pearl black, futuristic wheels, set in a reflective studio floor, polished cinematic render, 4K.",
        "A minimal crossover car, light blue, geometric silhouette, captured in soft golden-hour light, sharp detail, 4K photorealistic.",
        "A minimal sports car, pure silver, long exposure background blur, dynamic studio shot, ultra-detailed 4K.",
        "A minimal van concept, matte beige, no grille, presented in front of smooth concrete walls, architectural cinematic vibe, 4K clarity.",
        "A minimal futuristic taxi, yellow and black, glowing accents, parked on a white neon-lit street, cinematic lighting, 4K HDR.",
        "A minimal concept car, organic flowing shape, metallic finish, photographed in surreal white void, futuristic cinematic realism, 4K render."
    ]
}

struct LuxuryPrompts {
    static let all: [String] = [
        "A luxury sedan, champagne gold body, chrome grille, photographed in front of a modern mansion at dusk, cinematic 4K with golden lighting.",
        "A luxury limousine, glossy black, glowing city skyline reflection, captured with cinematic wide lens, 4K hyper-realistic detail.",
        "A luxury coupe, sapphire blue finish, crystal-like headlights, neon-lit upscale district, HDR cinematic quality, 4K.",
        "A luxury SUV, pearl white, oversized chrome wheels, desert road at sunset, cinematic lens flare, 4K clarity.",
        "A luxury convertible, ruby red with cream leather, parked by infinity pool, cinematic golden light, 4K photorealistic.",
        "A luxury concept car, two-tone black and silver, futuristic ambient lighting, glass dome roof, high-detail 4K cinematic render.",
        "A luxury sedan, emerald green, private jet blur backdrop, 4K cinematic realism.",
        "A luxury coupe, rose gold paint, reflective metallic finish, evening urban lights, cinematic sharp detail, 4K ultra render.",
        "A luxury EV, glossy black body, champagne bar inside, parked in futuristic smart city, cinematic lighting, 4K UHD.",
        "A wide-angle shot of a luxury limo, glass canopy shimmering, exterior glowing with soft lights, parked under a neon-lit futuristic cityscape, ultra-detailed."
    ]
}

struct SportyPrompts {
    static let all: [String] = [
        "A sleek red sporty coupe, shown completely as it speeds along the racetrack in a vivid 4K cinematic shot.",
        "A sporty roadster, bright yellow, convertible top down, driving on a coastal cliff road, dynamic cinematic angle, 4K realism.",
        "A sporty hatchback, metallic blue, drifting in city street, tire smoke around, cinematic detail, 4K clarity.",
        "A sporty EV supercar, silver matte body, futuristic aerodynamics, neon racetrack, 4K cinematic realism.",
        "A sporty racing car, neon green decals, captured mid-turn, sparks flying, dynamic cinematic action, 4K HDR.",
        "A sporty hybrid muscle car, black body with red stripes, burnout smoke, cinematic high-contrast 4K image.",
        "A sporty futuristic car, white metallic, hovering slightly, glowing blue lights, sci-fi cinematic realism, 4K.",
        "A sporty convertible, orange paint, sharp curve on mountain road, cinematic drone shot, 4K photorealistic.",
        "A sporty cyber-inspired car, glowing cyan edges, neon city background, cinematic futuristic style, 4K clarity.",
        "A sporty track car, pearl white, slick tires, pit crew visible, cinematic depth of field, 4K render."
    ]
}

struct MuscularPrompts {
    static let all: [String] = [
        "A muscular muscle car, matte black paint, smoky underground garage, dramatic cinematic lighting, 4K HDR.",
        "A muscular coupe, deep red body, oversized hood scoop, drag strip burnout, cinematic motion shot, 4K ultra clarity.",
        "A muscular EV, futuristic grille, glowing headlights, cyberpunk city street, cinematic realism, 4K neon detail.",
        "A muscular pickup truck, matte green, lifted suspension, dusty desert, cinematic high-contrast detail, 4K HDR.",
        "A muscular retro car, chrome flames on hood, captured on open highway, 4K cinematic nostalgia shot.",
        "A muscular widebody car, metallic silver, low stance, cinematic smoke effects, high detail, 4K photorealism.",
        "A muscular street racer, bright orange, neon tunnel reflections, dynamic cinematic angle, 4K HDR.",
        "A muscular SUV, matte brown finish, off-road dirt clouds, front view capture, cinematic desert adventure, 4K clarity.",
        "A muscular futuristic coupe, jet-black body with glowing red accents,  cyberpunk cinematic realism, 4K render.",
        "A powerful matte-blue dragster cruising steadily down an open road, shown fully in a crisp 4K HDR cinematic scene."
    ]
}

struct FuturisticPrompts {
    static let all: [String] = [
        "A futuristic hovercar, metallic purple glow, parked in neon-lit Tokyo alley, cyberpunk cinematic 4K render.",
        "A futuristic sedan, holographic body panels, glowing blue accents, rain-soaked cyber city, cinematic Blade Runner vibe, 4K UHD.",
        "A futuristic sports car, reflective chrome, levitating above neon grid, sci-fi cinematic detail, 4K HDR.",
        "A futuristic luxury coupe, silver dome roof, holographic driver interface, 4K cinematic realism.",
        "A futuristic cyberpunk taxi, yellow-black, holographic signs, neon city street, cinematic glow, 4K clarity.",
        "A futuristic EV racer, cyan neon lights, rainy street with reflections, high-detail 4K cinematic shot.",
        "A futuristic armored car with thick metal panels and bright orange edge lights, captured in a dystopian city backdrop in crisp 4K HDR.",
        "A futuristic SUV, glowing pink edges, neon-lit skyline, cyberpunk cinematic style, 4K UHD.",
        "A futuristic stealth coupe, matte black body with adaptive light panels, sliding under neon arches, sci-fi cinematic 4K detail.",
        "A futuristic race car, green glowing streaks, digital cyber racetrack, cinematic hyper-detail, 4K."
    ]
}

struct RetroPrompts {
    static let all: [String] = [
        "A retro 60s coupe, pastel blue, chrome bumpers, parked by diner, cinematic nostalgic 4K realism.",
        "A retro 70s muscle car, burnt orange, drag strip action, tire smoke, cinematic 4K HDR.",
        "A retro 80s hatchback, neon yellow, synthwave sunset backdrop, cinematic nostalgia, 4K clarity.",
        "A nostalgic 1960s-style red convertible, white interior shining, parked by the coast at dusk, captured in rich golden-hour 4K realism.",
        "A retro station wagon, turquoise paint, suburban street, cinematic vintage realism, 4K.",
        "A retro racing car, white with blue stripes, vintage racetrack setting, cinematic film look, 4K HDR.",
        "A retro-futuristic 50s bubble car, pastel pink, chrome fins, sci-fi backdrop, cinematic surreal 4K render.",
        "A retro 80s supercar, black with gold trim, neon city at night, synthwave cinematic 4K style.",
        "A retro pickup truck, forest green, countryside barn, cinematic nostalgic 4K HDR.",
        "A retro luxury sedan, cream white, parked in front of opera house, cinematic film look, 4K clarity."
    ]
}
