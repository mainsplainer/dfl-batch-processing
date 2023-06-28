$DFL_PATH = Get-Content -Path "paths.txt" -First 1

function GetVideoFolders($path) {
	$excluded_folders = @('model', 'data_src', 'data_dst', 'results', 'processed_srcs', 'aligned', 'New Folder')
	return Get-ChildItem -Path $DFL_PATH\workspace -Directory | Where-Object {$_.Name -notin $excluded_folders}
}

$index = 0
$video_folders = GetVideoFolders $DFL_PATH
$num_folders   = $video_folders.count
	
foreach ($folder in $video_folders) {
	$index++
	Write-Host ("FOLDER ({0:d3}/{1:d3}). {2}" -f $index, $num_folders, $folder.Name) -ForegroundColor Green

    	Set-Location -LiteralPath $folder.FullName
	Move-Item ".\data_dst" ..
	
	Set-Location ..\..\
	
	Write-Host "STEP (1/1): Packing Faceset" -ForegroundColor Yellow 
	echo "." | & .\"5.2) data_dst util faceset pack.bat"
	
	Set-Location "workspace"
	Move-Item "data_dst" $folder
}

RunDLL32 User32.dll,MessageBeep
Write-Host "Finished! (You may close this window!)" -ForegroundColor Green
pause
