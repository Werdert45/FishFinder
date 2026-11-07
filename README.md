# FishFinder

Point your phone at a fish and get the species, on the device, no signal needed. FishFinder is a Flutter app with a locally hosted classifier for 63 Dutch fish species, plus the training pipeline behind it. Every fish you identify unlocks its page in the FishDex, a Pokédex for Dutch fish.

![Three FishFinder screens: a scan result ranking blankvoorn at 94%, the blankvoorn species page, and the FishDex collection](https://ianronk.nl/projects/fishfinder-on-device-fish-id/app-screens-triptych.jpg)

## Result

- **63** Dutch fish species, trained on **~3,000** self-collected photos
- **8.8 MB** model on the phone, down from 90 MB
- **1** click per photo to mask the fish before training

## How it works

1. **Masking.** Nearly every photo has hands, a boat or grass in it. Segment Anything cuts out the fish with one click per photo, so the model learns fish and not anglers.
2. **Augmentation.** Data augmentation stretches the roughly 50 photos per species.
3. **Training.** A pretrained ResNet50 is fine-tuned on the masked photos.
4. **On the phone.** The model is converted to TFLite and ships inside the app, so classification runs on the device.

![FishFinder flow: the camera frames a fish, an on-device ResNet50 in TFLite classifies it, and the result unlocks a cell in the FishDex](https://ianronk.nl/projects/fishfinder-on-device-fish-id/app-flow-diagram.svg)

## What is where

| Folder | Contents |
|---|---|
| `model/` | Jupyter notebooks: `Segment Step` and `Quick Segment Step` (masking), `ResNet50Model` and `Fit Fish` (training); `annotation/` holds one file per species |
| `app/` | The Flutter app for iOS and Android; `lib_legacy/` is the earlier version |

## Run it

The app:

```bash
cd app
flutter pub get
flutter run
```

Sign-in and the FishDex use Firebase, so point `app/android/app/google-services.json` and `app/ios/GoogleService-Info.plist` at a Firebase project of your own.

The model: open the notebooks in `model/` with Jupyter, masking first, then training. The photos are not in the repository.

## Write-up

The full story, from masking to the 8.8 MB model: [FishFinder on ianronk.nl](https://ianronk.nl/en/research/fishfinder-on-device-fish-id).

## License

MIT, see [LICENSE](LICENSE). Questions: ian@ronk.org.
