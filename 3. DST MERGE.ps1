$DFL_PATH = Get-Content -Path "paths.txt" -First 1

function GetVideoFolders($path) {
	$excluded_folders = @('model', 'data_src', 'data_dst', 'results', 'processed_srcs', 'aligned', 'New Folder')
	return Get-ChildItem -Path $DFL_PATH\workspace -Directory | Where-Object {$_.Name -notin $excluded_folders}
}

$bitrate = Read-Host "Enter the bit-rate";
$index = 0
$video_folders = GetVideoFolders $DFL_PATH
$num_folders   = $video_folders.count
	
foreach ($folder in $video_folders) {
	$index++
	Write-Host ("FOLDER ({0:d3}/{1:d3}). {2}" -f $index, $num_folders, $folder.Name) -ForegroundColor Green

    Set-Location -LiteralPath $folder.FullName
	
	$video = Get-ChildItem -Path .\ | Where-Object { $_.Name -like "data_dst.*" }; 
	$video_extension = $video.Extension
	
	Move-Item * ..
	New-Item -ItemType Directory "data_dst" | Out-Null 
	
	Set-Location ..\..\
	
	Write-Host "STEP (1/3): Running Merger (close the merger window after merging is finished!)" -ForegroundColor Yellow 
	$process = Start-Process -FilePath ".\7) merge SAEHD.bat" -WindowStyle Normal -PassThru;
	$process.WaitForExit();
	
	Write-Host "STEP (2/3): Merging frames to video and mask" -ForegroundColor Yellow 
	echo $bitrate | & .\"8) merged to mp4.bat"
	
	Write-Host "STEP (3/3): Cleaning Up" -ForegroundColor Yellow
	Set-Location "workspace"
	Move-Item "data_dst$video_extension" $folder
	Move-Item "result.mp4"      $folder
	Move-Item "result_mask.mp4" $folder
	
	Set-Location "data_dst"
	Move-Item ".\aligned" $folder.FullName
	Set-Location -LiteralPath $folder.FullName
	Move-Item ".\aligned" "data_dst"
	
	Set-Location $DFL_PATH\workspace
	Remove-Item -Path ".\data_dst" -Recurse -Force
}

RunDLL32 User32.dll,MessageBeep
Write-Host "Finished! (You may close this window!)" -ForegroundColor Green
pause
