# NFPA704View

**UIView Subclass for NFPA 704 "Fire Diamonds"**

> This project is no longer maintained.

---

> "[NFPA 704: Standard System for the Identification of the Hazards of Materials for Emergency Response](http://en.wikipedia.org/wiki/NFPA_704)" is a standard maintained by the U.S.-based National Fire Protection Association. It defines the colloquial "fire diamond" used by emergency personnel to quickly and easily identify the risks posed by hazardous materials. This helps determine what, if any, special equipment should be used, procedures followed, or precautions taken during the initial stages of an emergency response.

![NFPA704View](https://raw.github.com/mattt/NFPA704View/screenshots/example.png)

## Usage

### Setting Hazards Manually

```objective-c
NFPA704View *fireDiamondView =
    [[NFPA704View alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];

fireDiamondView.flammability = NFPA704ModerateHazard;
fireDiamondView.health = NFPA704SlightHazard;
fireDiamondView.reactivity = NFPA704SeriousHazard;
fireDiamondView.specialNotice = NFPA704ReactsWithWaterSymbol;

[self.view addSubview:fireDiamondView];
```

### Setting Hazards from Material

```objective-c
@interface Chemical : NSObject <NFPA704Material>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *formula;

// ...

@end

fireDiamondView.material = [Chemical CH3CH2OH] // Ethyl Alcohol
// Flammability = 3, Health = 2, Reactivity = 0
```

### Contact

[Mattt](https://twitter.com/mattt)

## License

NFPA704View is available under the MIT license.
See the LICENSE file for more info.
