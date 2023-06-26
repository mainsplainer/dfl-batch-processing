# After steps 1, 2, and 3 move dst video and extracted faces to "swap/dst" and result to "swap/res"

try:
    import os
    import shutil

    # deepfacelab path : eg. E:\Tools\DeepFaceLab_NVIDIA_up_to_RTX2080Ti
    FOLDER_DIR = r"E:\Tools\DeepFaceLab_NVIDIA_up_to_RTX2080Ti"

    '''
    directory structure:

    swap:
        dst:
            {source}_{index}_{filename}
            tt_0001_vid1/aligned/faceset.pak
            tt_0001_vid1.mp4
            tt_0002_vid2/aligned/faceset.pak
            tt_0002_vid2.mp4
            .
            .
            .
        res:
            {subject}_{source}_{index}_{process}_{filename}
            sub_tt_0001_rg_vid1.mp4
            sub_tt_0002_rg_vid2.mp4
            .
            .
            .
    '''
    DATA_DST_DIR = r"E:\swap\dst"
    RESULT_DIR   = r"E:\swap\res"
    
    IGNORED_FOLDERS = ["data_dst", "model", "data_src"]

    default_video_type = "tt"
    video_type = input(f"[{default_video_type.rjust(4)}] Enter the video type    : ")
    video_type = video_type if video_type else default_video_type
    
    #default_starting_index = int([i for i in os.listdir(RESULT_DIR) if f"_{video_type}_" in i][-1].split("_")[2]) + 1
    default_starting_index = 1
    starting_index = input(f"[{default_starting_index:04d}] Enter the starting Index: ")
    starting_index = int(starting_index if starting_index else default_starting_index)
    
    default_subject = "sub"
    subject = input(f"[{default_subject.rjust(4)}] Enter the subject       : ")
    subject = subject if subject else default_subject
        
    default_result_process = "rg"
    result_process = input(f"[{default_result_process.rjust(4)}] Enter the result process: ")
    result_process = result_process if result_process else default_result_process
    
    print()
        
    os.chdir(FOLDER_DIR)
    for item in os.listdir(FOLDER_DIR):
        item_path = os.path.join(FOLDER_DIR, item)
        if os.path.isdir(item_path) and item not in IGNORED_FOLDERS:
        
            print(f"[INFO]: Processing Folder: {item}")
            os.chdir(item)
        
            new_folder_name = f"{DATA_DST_DIR}\{video_type}_{starting_index:04d}_{item}"
            new_result_name = f"{RESULT_DIR}\{subject}_{video_type}_{starting_index:04d}_{result_process}_{item}.mp4"
            
            os.rename("data_dst"  , new_folder_name)
            os.rename("result.mp4", new_result_name)
            os.rename("data_dst.mp4", f"{new_folder_name}.mp4")
            
            os.chdir("..")
            shutil.rmtree(item)
            starting_index += 1
            
except Exception as e:
    input(e)

input("Done!")