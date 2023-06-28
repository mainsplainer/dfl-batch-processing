try:
    import os
    import shutil
    
    with open("..\paths.txt", "r") as f:
        paths = f.read().split("\n")

    FOLDER_DIR   = paths[0] + "\workspace"
    DATA_DST_DIR = paths[1]
    RESULT_DIR   = paths[2]
    
    IGNORED_FOLDERS = ["data_dst", "model", "data_src"]

    default_video_type = "tt"
    video_type = input(f"[{default_video_type.rjust(4)}] Enter the video type    : ")
    video_type = video_type if video_type else default_video_type
    
    videos = [i for i in os.listdir(RESULT_DIR) if f"_{video_type}_" in i]
    default_starting_index = int(videos[-1].split("_")[2]) + 1 if videos else 1
    starting_index = input(f"[{default_starting_index:04d}] Enter the starting Index: ")
    starting_index = int(starting_index if starting_index else default_starting_index)
    
    default_subject = "shr"
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