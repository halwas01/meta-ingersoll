sudo rm /systemFiles.tar
sudo sh createSystemFilesPackage.sh
sudo sh createEssePackage.sh
sudo sh createEssePackage.sh PACKAGE /systemFiles.tar
sudo sh createEssePackage.sh CUSTOM_SCRIPT /systemFilesUpdateCustomScript.sh
sudo sh createEssePackage.sh BINS
sudo sh createEssePackage.sh WBA
sudo sh createEssePackage.sh UI
sudo sh createEssePackage.sh IRB

