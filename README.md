# 🎬 dfl-batch-processing
🚀 Batch process (EXTRACT, PACK and MERGE) hundreds of videos with these PowerShell scripts!

ℹ️ You may place these files anywhere but first make sure to set your **deepfacelab path** in "paths.txt".

📁 First, place all your videos (srcs or dsts) in the workspace directory. It should look something like this:

```
├── workspace
│   ├── model
│   │   └── (model files)
│   ├── video1.mp4
│   ├── video2.mp4
│   ├── video3.mp4
│   │  .
│   │  .
│   │  .
```

*(Right-click and run with PowerShell)*

0. **SRC EXTRACT.ps1**: Extract src faces from multiple videos at once.
1. **DST EXTRACT.ps1**: Extract dst faces from multiple videos at once into their respective folders.
2. **DST PACK.ps1**: Pack the extracted faces after removing any bad or misaligned faces.
3. **DST MERGE.ps1**: Batch merge to mp4.
