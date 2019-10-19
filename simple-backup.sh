#!/bin/bash

## Color Scheme

export RED='\033[1;31m'
export GREEN='\033[1;32m'
export NC='\033[0m' # No Color

path="/home/${USER}/Documents/personal_files"

destination="/home/${USER}/Nextcloud/Encrypted"

output="/home/${USER}/Documents/Decrypted"

trap '' 2
while true
do
  clear
  echo "================================================================================"
  echo "//                    Simple backup made by @squadramunter                    //"
  echo "================================================================================"
  echo "Enter 1 to create an encrypted backup of your files: "
  echo "Enter 2 to restore your encrypted backup: "
  echo "Enter 3 to remove a backup: "
  echo "Enter q to exit the menu q: "
  echo -e "\n"
  echo -e "Enter your selection \c"
  read answer
  case "$answer" in
1)

##Encrypt
DT=`date "+%Y-%m-%d-%H-%M-%S"`

tar -czf - ${path} | openssl enc -e -des3 -salt -pbkdf2 -out ${destination}/${USER}-secured-$DT.tar.gz -pass file:/etc/backup/passkey

echo -e "${GREEN}Your files are succesfully Encrypted!${NC}"

;;

2)

##Decrypt

echo -e "${GREEN}Enter the number of the file you want to decrypt:${NC}"

select FILENAME in ${destination}/*.tar.gz;
do
     echo "You picked $FILENAME ($REPLY), Now decrypting your archive!"
     chmod go-rwx "$FILENAME"
     DT=`date "+%Y-%m-%d-%H-%M-%S"`

     mkdir -p ${output}/${DT}

     openssl enc -d -des3 -salt -pbkdf2 -in ${FILENAME} -pass file:/etc/backup/passkey | tar xz -C ${output}/${DT}
break
done

echo -e "${GREEN}Encrypted files are succesfully Decrypted to your destination!${NC}"

;;

3)

## Remove a backup
echo -e "${RED}Enter the number of the backup you want to remove:${NC}"

select FILENAME in ${destination}/*;
do

read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        echo -e "${GREEN}You picked $FILENAME ($REPLY), Now removing your backup!${NC}"
        rm -rf "$FILENAME"
        ;;
    *)
        break
        ;;
esac

break
done

;;

q) exit ;;

  esac
  echo -e "Enter return to continue \c"
  read input
done
