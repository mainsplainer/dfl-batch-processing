# 🎬 dfl-batch-processing
🚀 Batch process (EXTRACT, PACK and MERGE) hundreds of (dst) videos with these PowerShell scripts!

ℹ️ **Before you begin**: Make sure to set your **deepfacelab path** in the EXTRACT, PACK, and MERGE scripts. Then follow these steps:
1. 📁 First, place all your dst videos in the workspace directory (just like where you would put data_dst.mp4). It should look something like this:

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

2. 📦 **EXTRACT**: After extraction, manually remove any bad or misaligned faces.
3. 🎒 **PACK (optional)**: Pack the extracted faces into "faceset.pak".
4. 🔄 **MERGE**: The merging process is still manual, but the videos will be merged automatically. *(Make sure the model is present. You can comment the "generic mask" and uncomment the "trained mask" in the MERGE script if you have a trained xseg model.)*
5. ✅ **FINISH**: Move data_dst video(s) + their extracted facesets and result(s) to seperate folders.
