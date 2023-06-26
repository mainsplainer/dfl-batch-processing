# deepfacelab path : eg. E:\Tools\DeepFaceLab_NVIDIA_up_to_RTX2080Ti
$df_path = "E:\Tools\DeepFaceLab_NVIDIA_up_to_RTX2080Ti"

$excluded_folders = @('model', 'data_src', 'data_dst', 'results')
$video_folders = Get-ChildItem -Path $df_path\workspace -Directory | Where-Object {$_.Name -notin $excluded_folders}

$index = 0
$num_folders = $video_folders.count
	
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
Write-Host "Finished!"
pause