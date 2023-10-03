#!/bin/bash


if [ -d "/etc/systemd/system" ]; then
  echo "|---------------------------|"
  echo -e "|***** \e[33mINSTALL SERVICE\e[0m *****|"
  echo "|---------------------------|"
  
  sleep 2 &&
  
  pwd_install=$(pwd) &&
  escaped_pwd_install=$(printf '%s\n' "$pwd_install" | sed -e 's/[\/&]/\\&/g') &&
  
  echo ""
  echo "|------------------------------|"
  echo -e "|***** \e[33mUPDATE ENVIRONMENT\e[0m *****|"
  echo "|------------------------------|"
  echo ""
  
  sleep 2 &&
  
  sudo sed -i "s#ExecStart=.*#ExecStart=$escaped_pwd_install/service/giteaService.sh#" $pwd_install/service/giteaHook.service &&
  echo -e "* \e[32mExecStart\e[0m *" &&
  sleep 1 && 

  sudo sed -i "s#WorkingDirectory=.*#WorkingDirectory=$escaped_pwd_install/service#" $pwd_install/service/giteaHook.service &&
  echo -e "* \e[32mWorkingDirectory\e[0m *" &&
  sleep 1 &&

  sudo sed -i "s#EnvironmentFile=.*#EnvironmentFile=$escaped_pwd_install/service/giteaService#" $pwd_install/service/giteaHook.service &&
  echo -e "* \e[32mEnvironmentFile\e[0m *" &&
  sleep 1 &&

  sudo sed -i "s#HOOK_PATH=.*#HOOK_PATH=$escaped_pwd_install#" $pwd_install/service/giteaService &&
  echo -e "* \e[32mHOOK_PATH\e[0m *" &&
  sleep 1 &&

  sudo sed -i "s#source .*#source $escaped_pwd_install/service/giteaService#" $pwd_install/service/giteaHook.sh &&
  echo -e "* \e[32mEXEC_FILE\e[0m *" &&
  echo ""
  sleep 1 &&

  systemctl stop giteaHook.service 
  
  input_file="$pwd_install/service/giteaService" &&

  #Doc va xu ly tung dong
  while IFS= read -r line; do 
    # Kiem tra xem d?ng c� ch?a "_PATH" kh�ng
    if [[ $line == *"_PATH"* ]]; then
      # Lay string sau dau "="
      path="${line#*=}"
      # Loai bo khoang trong trong duong dan
      path=$(echo "$path" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
      # Kiem tra duong dan ton tai
      if [ ! -e "$path" ]; then
        echo ""
        echo -e "\e[41mError: $path not exists.\e[0m"
        echo ""
        exit 1  # D?ng ch��ng tr?nh
      else
        echo -e "\e[32mOK: $path exists\e[0m"
        sleep 1
      fi
    fi
  done < "$input_file" &&
  
  cp $pwd_install/service/giteaHook.service /etc/systemd/system/giteaHook.service &&
  echo "" &&
  echo -e "* \e[32mCopy service file\e[0m *" &&
  
  systemctl daemon-reload &&
  
  echo "" &&
  echo "|----------------------|" &&
  echo -e "|*** \e[33mENABLE SERVICE\e[0m ***|" &&
  echo "|----------------------|" &&
  echo "" &&
  
  systemctl enable giteaHook &&
  
  sleep 2 &&
  
  echo "|---------------------|" &&
  echo -e "|*** \e[33mSTART SERVICE\e[0m ***|" &&
  echo "|---------------------|" &&
  echo "" &&
  
  systemctl start giteaHook &&

  sleep 2 &&
  
  echo "|------------|" &&
  echo -e "|*** \e[33mDONE\e[0m ***|" &&
  echo "|------------|" &&
  echo "" &&
  
  sleep 1 &&
  
  echo "|--------------|" &&
  echo -e "|** \e[33mGOODLUCK\e[0m **|" &&
  echo "|--------------|" &&
  echo "" &&
  
  journalctl -u giteaHook -f

else
  echo "/etc/systemd/system directory does not exist. Please check!"
fi
