#!/bin/sh

RESPONSE_FILE=install_tuxedo.rsp

# variables by default
RESPONSEFILE_VERSION=2.2.1.0.0
UNIX_GROUP_NAME="\"`groups`\""
FROM_LOCATION="\"`pwd`/../stage/products.xml\""
SHOW_WELCOME_PAGE=false
SHOW_CUSTOM_TREE_PAGE=false
SHOW_COMPONENT_LOCATIONS_PAGE=false
SHOW_SUMMARY_PAGE=false
SHOW_INSTALL_PROGRESS_PAGE=false
SHOW_REQUIRED_CONFIG_TOOL_PAGE=false
SHOW_CONFIG_TOOL_PAGE=false
SHOW_RELEASE_NOTES=false
SHOW_ROOTSH_CONFIRMATION=true
SHOW_END_SESSION_PAGE=false
SHOW_EXIT_CONFIRMATION=false
NEXT_SESSION=false
NEXT_SESSION_ON_FAIL=true
DEINSTALL_LIST={\"Tuxedo\",\"12.2.2.0.0\"}
SHOW_DEINSTALL_CONFIRMATION=false
SHOW_DEINSTALL_PROGRESS=false
CLUSTER_NODES={}
ACCEPT_LICENSE_AGREEMENT=false
METALINK_USERNAME="\"\""
PROXY_HOST="\"\""
PROXY_PORT="\"\""
PROXY_USER="\"\""
TOPLEVEL_COMPONENT={\"Tuxedo\",\"12.2.2.0.0\"}
SHOW_SPLASH_SCREEN=false
SELECTED_LANGUAGES={\"en\"}
COMPONENT_LANGUAGES={\"en\"}
TLISTEN_PORT="\"3050\""
ENCRYPT_CHOICE=0
MIN_CRYPT_BITS_CHOOSE=0
MAX_CRYPT_BITS_CHOOSE=3

#variables specified with input
INVENTORY=""
ORACLE_HOME=""
ORACLE_HOME_NAME=""
INSTALL_TYPE=""
ENABLE_TSAM_AGENT=true
INSTALL_SSL=true
LDAP_SUPPORT_SSL=true
LDAP_CONFIG="{\"\",\"\",\"\"}"
LDAP_FILTER_FILE="\"\""
INSTALL_SAMPLES=false
CONFIG_TLISTEN=true
TLISTEN_PASSWORD="\"\""

#variables for output
GOBACK="0- Go back"

# check JAVA_HOME and java version.
check_java(){
if [ x${JAVA_HOME} = x ];then
        echo "JAVA_HOME is not set"
        exit 1
fi

_java=${JAVA_HOME}/bin/java

if [ ! -x $_java ];then
        echo "$_java can not be executed"
        exit 1
fi

version=`"$_java" -version 2>&1 | $_awk -F '"' '/version/ {print $2}'`
versionnum=`echo $version |$_awk -F '.' '{print $2}'`
if [ $versionnum -lt 6 ]; then
        echo version is less than 1.6
        exit 1
fi 
}


page_introduction(){
flag_introduction=0
echo "==============================================================================="
echo "Introduction"
echo "------------------"
echo ""
echo ""
echo "This shell script guides you through the installation and configuration of your Oracle Products. Press \"Enter\" to accept the default and proceed to the next screen."

while [ $flag_introduction -eq 0 ]
do
$_echo "Press \"Enter\" to continue: \c"
read number
case $number in
next | "")     
     flag_introduction=1
     ;;
*)
     $_echo "error choice\n"
     continue
     ;;
esac
echo ""
echo ""
echo ""
done

}

check_central_inventory(){
OS=`uname -s`
if [ $OS = "Linux" ] || [ $OS = "AIX" ];then
    pointfile="/etc/oraInst.loc"
elif [ $OS = "SunOS" ] || [ $OS = "HP-UX" ];then
    pointfile="/var/opt/oracle/oraInst.loc"
else
    exit 1
fi

if [ -f $pointfile ];then
    $_echo " $pointfile exists\n"
    $_java Check InventoryDir $pointfile
    status=$?
    if [ $status -ne 0 ];then
        $_echo "CheckInventoryDir failed\n"
        exit 1
    fi
else
    $_echo " Warning: $pointfile doesn't exist."
    $_echo " You can run $HOME/oraInventory/orainstRoot.sh as root to create one after the installation."
    pointfile=""
fi

}

check_private_inventory(){
flag_private_inventory=0
while [ $flag_private_inventory -eq 0 ]
do    
flag_private_inventory=1
$_echo "Enter your private inventory pointer file: \c"
read invPtrLocFile
if [ "$invPtrLocFile" = "" ];then
    $_echo "invalid inventory pointer file: $invPtrLocFile\n"
    flag_private_inventory=0
    continue
fi 
if [ -d $invPtrLocFile ] ;then
    $_echo "invalid inventory pointer file: $invPtrLocFile\n"
    flag_private_inventory=0
    continue
fi
if [ -f $invPtrLocFile ];then
    if [ -r $invPtrLocFile ];then
        $_java Check InventoryDir $invPtrLocFile
        status=$?
        if [ $status -ne 0 ];then
            $_echo "CheckInventoryDir failed\n"
            flag_private_inventory=0 
            continue          
        fi
    else
        $_echo "No permission to read $invPtrLocFile\n"
        flag_private_inventory=0
        continue
    fi
else
    parentdir=`dirname $invPtrLocFile`
    if [ ! -d $parentdir ] || [ $parentdir = "." ];then
        $_echo "invalid inventory pointer file: $invPtrLocFile\n"
        flag_private_inventory=0
        continue
    fi
    if [ ! -w $parentdir ];then
        $_echo "No permission to write $parentdir\n"
        flag_private_inventory=0
        continue
    fi
    $_echo " $invPtrLocFile doesn't exist, please create it\n"

    flag_inventory_directory=0
    while [ $flag_inventory_directory -eq 0 ]
    do
    flag_inventory_directory=1
    $_echo "Enter private inventory directory: \c"
    read directory
    if [ "$directory" = "" ];then
         $_echo "private inventory directory should not be null\n"
         flag_inventory_directory=0
         continue
    fi
    parentdir=`dirname $directory`
    if [ ! -d $parentdir ] || [ $parentdir = "." ];then
        $_echo "invalid inventory directory: $directory\n"
        flag_inventory_directory=0
        continue
    fi
    if [ ! -w $parentdir ];then
        $_echo "No permission to write $parentdir\n"
        flag_inventory_directory=0
        continue
    fi
    if [ -f $directory ];then
        $_echo "invalid inventory directory: $directory\n"
        flag_inventory_directory=0
        continue
    fi
    if [ -d $directory ] && [ ! -w $directory ];then
        $_echo "No permission to write $directory\n"
        flag_inventory_directory=0
        continue
    fi    
    done
    echo "inventory_loc=$directory" > $invPtrLocFile

    flag_inventory_inst_group=0
    while [ $flag_inventory_inst_group -eq 0 ]
    do
    flag_inventory_inst_group=1    
    $_echo "Enter inst_group: \c"
    read inst_group 
    if [ "$inst_group" = "" ];then
        $_echo "inst_group should not be null\n"
        flag_inventory_inst_group=0
        continue
    fi
    done
    echo "inst_group=$inst_group" >> $invPtrLocFile              
fi
done

}

# select central inventory or private inventory
page_inventory_choose(){
flag_inventory_choose=0;
while [ $flag_inventory_choose -eq 0 ]
do
echo "==============================================================================="
echo "Choose Inventory"
echo "------------------"
echo ""
echo ""
    echo "->1- Central Inventory"
    echo "2- Private Inventory"
    echo $GOBACK
echo ""
$_echo "Enter a number: \c"
read number
case $number in
1 | next | "")   
     check_central_inventory
     flag_inventory_choose=1
     INVENTORY=$pointfile
     ;;
2) 
     check_private_inventory
     flag_inventory_choose=1
     INVENTORY=$invPtrLocFile
     ;;
0 | back)
     page_introduction
     continue
     ;;
*)
     echo "error choice"
     continue
     ;;
esac
echo ""
echo ""
echo ""
done
}


check_existing_oracle_home(){
flag_check_existing_oracle_home=0
if [ "$oracle_home_info" = "ERROR" ]; then
    $_echo "check_existing_oracle_home failed\n"
    exit 1
else
    while [ $flag_check_existing_oracle_home -eq 0 ]
    do
    $_echo "\nPlease choose number from the following Oracle Home List: "
    echo $oracle_home_info | $_awk -F";" '{OFS="\n";for(i=1;i<NF;i++)print $i}'
    $_echo $GOBACK
    $_echo ""
    $_echo "Enter a number: \c"
    read number
    case $number in
    0)
        flag_choose_return=1  
        flag_check_existing_oracle_home=1
        continue
        ;;
    [1-9])
        ;;
    [1-9][0-9])
        ;;
    *)
        $_echo "error choice\n"
        continue
        ;;
    esac
    if [ $number -gt $oracle_home_number ];then
        $_echo "error choice\n"
        continue
    fi
    oracle_home=`echo $oracle_home_info | $_awk -F";" -v oracle_home_info=$number '{print $oracle_home_info}' | $_awk '{print $2}'`
    if [ ! -d $oracle_home ];then
        $_echo "can not find $oracle_home, please choose another one\n"
        continue
    fi
    if [ ! -w $oracle_home ];then
        $_echo "No write permission for $oracle_home, please choose another one\n"
        continue
    fi
    var=`$_java Check TuxedoInstalled $oracle_home`
    # $var = "11" : tuxedo is installed and version match
    if [ "$var" = "11"  ];then
        $_echo "You have installed Tuxedo under $oracle_home.The installed product will be overrided partially\n"
        #$_echo "Press \"Enter\" to continue, Press any othe key to choose another oracle_home: \c"
        $_echo "->1- Continue"
        $_echo $GOBACK
        $_echo ""
        $_echo "Enter a number: \c"
        read number
        case $number in
        1 | next | "") 
            ;;
        0)
            continue
            ;;
        *)
            $_echo "error choice\n"
            continue
            ;;
        esac
    # $var = "10": tuxedo is installed and version not match
    elif [ "$var" = "10" ];then
        $_echo "Another version Tuxedo is installed,please choose another oracle_home\n"
        continue
    # $var = "00": tuxedo is not installed. 
    elif [ "$var" != "00" ];then
        #$_echo Check returncode is $var
        $_echo "Check TuxedoInstalled failed,please choose another oracle_home\n"
        continue
    fi
    ORACLE_HOME="\"$oracle_home\""
    ORACLE_HOME_NAME="\"`$_java Check OracleHomeName $INVENTORY $oracle_home`\""
    flag_check_existing_oracle_home=1
    done
fi

}

check_new_oracle_home(){
flag_check_new_oracle_home=0
var=`$_java Check OracleHome $INVENTORY`
if [ "$var" = "ERROR" ]; then
    #$_echo "check_existing_oracle_home failed\n"
    $_echo "Check ORACLE_HOME failed\n"
    exit 1
else
    while [ $flag_check_new_oracle_home -eq 0 ]
    do
    $_echo "Enter ORACLE_HOME: \c"
    read oracle_home
    if [ "$oracle_home" = "" ];then
        $_echo "ORACLE_HOME should not be null\n"
        continue
    fi
    parentdir=`dirname $oracle_home`
    if [ -f $oracle_home ]; then
        $_echo "$oracle_home is not a directory\n"
        continue
    fi
    if [ -d $oracle_home ];then
        if [ "$(ls -A $oracle_home)" ]; then
            $_echo "$oracle_home is not empty. It is recommended to specify either an empty or a non-existent directory.\n"
            $_echo "Do you still want to use this folder as ORACLE_HOME?\n"
            $_echo "1- Yes"
            $_echo $GOBACK
            $_echo ""
            $_echo "Enter a number: \c"
            read number
            case $number in
            1) 
                ;;
            0)
                continue
                ;;
            *)
                $_echo "error choice\n"
                continue
                ;;
            esac
        fi
    fi
    if [ ! -d $parentdir ] || [ $parentdir = "." ];then
        $_echo "Invalid ORACLE_HOME: $oracle_home\n"
        continue
    fi
    if [ ! -w $parentdir ];then
        $_echo "No permission to write $parentdir\n"
        continue
    fi
    status=`echo $var | $_awk -F";" -v home=$oracle_home '{for(i=1;i<NF;i++){if($i == i"- "home)print "ERROR"}}' `
    if [ "$status" = "ERROR" ];then
        $_echo "$oracle_home already exists\n"
        continue
    fi

    flag_oracle_home_name=0
    while [ $flag_oracle_home_name -eq 0 ]
    do
    $_echo "Enter ORACLE_HOME_NAME: \c"
    read oracle_home_name
    if [ "$oracle_home_name" = "" ];then
        $_echo "ORACLE_HOME_NAME should not be null\n"
        continue
    fi
    flag_oracle_home_name=1
    done

    ORACLE_HOME="\"$oracle_home\""
    ORACLE_HOME_NAME="\"$oracle_home_name\""
    flag_check_new_oracle_home=1
    done
fi

}

page_oracle_home_choose(){
flag_oracle_home_choose=0;
while [ $flag_oracle_home_choose -eq 0 ]
do
flag_choose_return=0;
echo "==============================================================================="
echo "Choose Oracle Home"
echo "------------------"
echo ""
echo ""
    echo "->1- Create new Oracle Home"
    echo "2- Use existing Oracle Home"
    echo $GOBACK
echo ""
$_echo "Enter a number: \c"
read number
case $number in
1 | next | "")
    check_new_oracle_home
    flag_oracle_home_choose=1
    ;;
2)  
    oracle_home_info=`$_java Check OracleHome $INVENTORY`
    oracle_home_number=`echo $oracle_home_info | $_awk -F";" '{ print NF-1}'`
    if [ $oracle_home_number -le 0 ];then
        $_echo "No oracle home available,please choose to create new Oracle Home\n"
        continue
    else        
        check_existing_oracle_home
        if [ $flag_choose_return -eq 1 ];then
            continue
        fi
        flag_oracle_home_choose=1
    fi
    ;;
0 | back)
    page_inventory_choose
    continue
    ;;
*)
    $_echo "error choice\n"
    continue
    ;;
esac
echo ""
echo ""
echo ""
done
}

page_install_set_choose(){
flag_install_set_choose=0;
while [ $flag_install_set_choose -eq 0 ]
do
echo "==============================================================================="
echo "Choose Install Set"
echo "------------------"
echo ""
echo "Please choose the Install Set to be installed by this installer."
echo ""
  echo "->1- Full Install"
    echo "2- Server Install"
    echo "3- Client Install"
    echo $GOBACK
#    echo "4- Custom Install"
echo ""
$_echo "Enter a number: \c"
read number
case $number in
1 | next | "")
     INSTALL_TYPE="\"Full Install\""
     flag_install_set_choose=1
     ;;
2)
     INSTALL_TYPE="\"Server Install\""
     flag_install_set_choose=1
     ;;
3)
     INSTALL_TYPE="\"Client Install\""
     flag_install_set_choose=1
     ;;  
0 | back)
     page_oracle_home_choose
     continue
     ;;
*)
     $_echo "error choice\n"
     continue
     ;;
esac
echo ""
echo ""
echo ""
done
}

page_tsam_enable(){
flag_tsam_enable=0
while [ $flag_tsam_enable -eq 0 ]
do
echo "==============================================================================="
echo "Confirm Enable TSAM Plus Agent"
echo "------------------"
echo ""
echo "Would you like to enable TSAM(Tuxedo System and Applications Monitor) Plus Agent?"
echo ""
  echo "->1- Yes"
    echo "2- No"
    echo $GOBACK
echo ""
$_echo "Enter a number: \c"
read number
case $number in
1 | next | "")
     ENABLE_TSAM_AGENT=true
     flag_tsam_enable=1
     ;;
2)
     ENABLE_TSAM_AGENT=false
     flag_tsam_enable=1
     ;;
0 | back)
     page_install_set_choose
     continue
     ;;
*)
     $_echo "error choice\n"
     continue
     ;;
esac
echo ""
echo ""
echo ""
done
}

LDAP_configuration(){
echo "------------------"
echo "Enter Your LDAP Settings For SSL Support"
echo "------------------"
echo ""
flag_LDAP_service_name=0
while [ $flag_LDAP_service_name -eq 0 ]
do    
$_echo "Input LDAP Service Name: \c"  
read LDAP_service_name
if [ "$LDAP_service_name" = "" ];then
    $_echo "LDAP Service Name should not be null\n"
    continue
fi
flag_LDAP_service_name=1
done

flag_LDAP_portID=0
while [ $flag_LDAP_portID -eq 0 ]
do   
$_echo "Input LDAP PortID: \c"
read LDAP_portID
if [ "$LDAP_portID" = "" ];then
    $_echo "LDAP_portID should not be null\n"
    continue
fi
flag_LDAP_portID=1
done   

flag_LDAP_baseobject=0
while [ $flag_LDAP_baseobject -eq 0 ]
do   
$_echo "Input LDAP BaseObject: \c"
read LDAP_baseobject
if [ "$LDAP_baseobject" = "" ];then
    $_echo "LDAP_baseobject should not be null\n"
    continue
fi
flag_LDAP_baseobject=1
done   

LDAP_CONFIG="{\"$LDAP_service_name\",\"$LDAP_portID\",\"$LDAP_baseobject\"}"
}

LDAP_filter_file_choose(){
flag_LDAP_filter_file_choose=0
while [ $flag_LDAP_filter_file_choose -eq 0 ]
do
flag_LDAP_filter_file_choose=1
echo "LDAP Filter File: "
$_echo "   Press <Enter> to accept the default: $oracle_home/udataobj/security/bea_ldap_filter.dat or enter your own: \c"
read input
if [ x$input = x"" ]; then
    LDAP_FILTER_FILE="\"$oracle_home/udataobj/security/bea_ldap_filter.dat\""
else
    LDAP_FILTER_FILE="\"$input\""
    if [ -d $input ];then
    $_echo "invalid LDAP Filter File: $input\n"
    flag_LDAP_filter_file_choose=0
    continue
    fi
    if [ -f $input ];then
        if [ ! -w $input ];then
            $_echo "No permission to write $input \n"
            flag_LDAP_filter_file_choose=0 
            continue   
        fi       
    else
        parentdir=`dirname $input`
        if [ ! -d $parentdir ] || [ $parentdir = "." ];then
            $_echo "invalid LDAP Filter File: $input\n"
            flag_LDAP_filter_file_choose=0
            continue
        fi
        if [ ! -w $parentdir ];then
            $_echo "No permission to write $parentdir\n"
            flag_LDAP_filter_file_choose=0
            continue
        fi
    fi
fi
done
}

LDAP_support_choice(){
flag_LDAP_support_choice=0
while [ $flag_LDAP_support_choice -eq 0 ]
do
echo "------------------"
echo "LDAP Support Choice"
echo "------------------"
echo ""
echo "Would you like to configure LDAP for SSL Support?"
echo ""
  echo "->1- Yes"
    echo "2- No"
    echo $GOBACK
echo ""
$_echo "Enter a number: \c"
read number
case $number in
0 | back)
     flag_support_return=1
     flag_LDAP_support_choice=1
     continue
     ;;
1 | next | "")
     LDAP_SUPPORT_SSL=true
     LDAP_configuration
     LDAP_filter_file_choose
     flag_LDAP_support_choice=1
     ;;
2)
     LDAP_SUPPORT_SSL=false
     flag_LDAP_support_choice=1
     ;;
*)
     $_echo "error choice\n"
     continue
     ;;
esac
done
}


page_SSL_support_choice(){
flag_SSL_support_choice=0
while [ $flag_SSL_support_choice -eq 0 ]
do
flag_support_return=0;
echo "==============================================================================="
echo "SSL Support Choice"
echo "------------------"
echo ""
echo "Would you like to Support SSL"
echo ""
  echo "->1- Yes"
    echo "2- No"
    echo $GOBACK
echo ""
$_echo "Enter a number: \c"
read number
case $number in
1 | next | "")
     INSTALL_SSL=true
     LDAP_support_choice
     if [ $flag_support_return -eq 1 ];then
        continue
     fi
     flag_SSL_support_choice=1
     ;;
2)
     INSTALL_SSL=false
     flag_SSL_support_choice=1
     ;;
0 | back)
     page_tsam_enable
     continue
     ;;
*)
     $_echo "error choice\n"
     continue
     ;;
esac
echo ""
echo ""
echo ""
done
}





page_samples_installation(){
flag_samples_installation=0
while [ $flag_samples_installation -eq 0 ]
do
echo "==============================================================================="
echo "Samples Installation Choice"
echo "------------------"
echo ""
echo "Would you like to install Oracle Tuxedo Samples?"
echo ""
  echo "->1- Yes"
    echo "2- No"
    echo $GOBACK
echo ""
$_echo "Enter a number: \c"
read number
case $number in
1 | next | "")
     INSTALL_SAMPLES=true
     flag_samples_installation=1
     ;;
2)
     INSTALL_SAMPLES=false
     flag_samples_installation=1
     ;;
0 | back)
     page_SSL_support_choice
     continue
     ;;
*)
     $_echo "error choice\n"
     continue
     ;;
esac
echo ""
echo ""
echo ""
done
}


configure_tlisten(){
flag_tlisten=0
while [ $flag_tlisten -eq 0 ]
do
$_echo "Enter Password: \c"
stty -echo
read  password
if [ "$password" = "" ];then
    stty echo
    $_echo "Password should not be null\n"
    continue
fi
stty echo
echo ""
$_echo "Verify Password: \c"
stty -echo
read vpassword
stty echo
echo ""
if [ "$password" = "$vpassword" ];then
    flag_tlisten=1
else
    $_echo "Password is not match\n"
    continue
fi
done
}


page_configure_tlisten(){
flag_configure_tlisten=0
while [ $flag_configure_tlisten -eq 0 ]
do
echo "==============================================================================="
echo "Tlisten Configuration Choice"
echo "------------------"
echo ""
echo "Would you like to configure Oracle Tuxedo tlisten?"
echo ""
  echo "->1- Yes"
    echo "2- No"
    echo $GOBACK
echo ""
$_echo "Enter a number: \c"
read number
case $number in
1 | next | "")
     CONFIG_TLISTEN=true
     configure_tlisten
     TLISTEN_PASSWORD="\"$password\""
     flag_configure_tlisten=1
     ;;
2)
     CONFIG_TLISTEN=false
     flag_configure_tlisten=1
     ;;
0 | back)
     page_samples_installation
     continue
     ;;
*)
     $_echo "error choice\n"
     continue
     ;;
esac
echo ""
echo ""
echo ""
done
}

page_summary(){
flag_page_summary=0
while [ $flag_page_summary -eq 0 ]
do
echo "==============================================================================="
echo "Pre-Installation Summary"
echo "------------------"
echo ""
echo "Install type: $INSTALL_TYPE"
echo "Install Folder: $ORACLE_HOME"
echo ""
#$_echo "Press \"Enter\" to start installation, Or Enter \"0\" to go back: \c"
$_echo "->1- Start installation"
$_echo $GOBACK
$_echo ""
$_echo "Enter a number: \c"
read input
case $input in
1 | next | "")
     flag_page_summary=1
     ;;
0 | back)
     page_configure_tlisten
     continue
     ;;
*)
     $_echo "error choice\n"
     continue
     ;;
esac
echo ""
echo ""
echo ""
done
}


generate_response_file(){
echo "####################################################################">$RESPONSE_FILE
echo "## Copyright (c) 1999, 2015 Oracle. All rights reserved.          ##">>$RESPONSE_FILE
echo "##                                                                ##">>$RESPONSE_FILE
echo "## Specify values for the variables listed below to customize     ##">>$RESPONSE_FILE
echo "## your installation.                                             ##">>$RESPONSE_FILE
echo "##                                                                ##">>$RESPONSE_FILE
#echo "## Each variable is associated with a comment. The comment        ##">>$RESPONSE_FILE
#echo "## identifies the variable type.                                  ##">>$RESPONSE_FILE
#echo "##                                                                ##">>$RESPONSE_FILE
#echo "## Please specify the values in the following format:             ##">>$RESPONSE_FILE
#echo "##                                                                ##">>$RESPONSE_FILE
#echo "##         Type         Example                                   ##">>$RESPONSE_FILE
#echo "##         String       "Sample Value"                            ##">>$RESPONSE_FILE
#echo "##         Boolean      True or False                             ##">>$RESPONSE_FILE
#echo "##         Number       1000                                      ##">>$RESPONSE_FILE
#echo "##         StringList   {"String value 1","String Value 2"}       ##">>$RESPONSE_FILE
#echo "##                                                                ##">>$RESPONSE_FILE
#echo "## The values that are given as <Value Required> need to be       ##">>$RESPONSE_FILE
#echo "## specified for a silent installation to be successful.          ##">>$RESPONSE_FILE
#echo "##                                                                ##">>$RESPONSE_FILE
#echo "##                                                                ##">>$RESPONSE_FILE
echo "## This response file is generated by runInstallConsole.sh.       ##">>$RESPONSE_FILE
echo "####################################################################">>$RESPONSE_FILE
# echo default variables to response file
echo "RESPONSEFILE_VERSION=$RESPONSEFILE_VERSION">>$RESPONSE_FILE
echo "UNIX_GROUP_NAME=$UNIX_GROUP_NAME">>$RESPONSE_FILE
echo "FROM_LOCATION=$FROM_LOCATION">>$RESPONSE_FILE
echo "SHOW_CUSTOM_TREE_PAGE=$SHOW_CUSTOM_TREE_PAGE">>$RESPONSE_FILE
echo "SHOW_COMPONENT_LOCATIONS_PAGE=$SHOW_COMPONENT_LOCATIONS_PAGE">>$RESPONSE_FILE
echo "SHOW_SUMMARY_PAGE=$SHOW_SUMMARY_PAGE">>$RESPONSE_FILE
echo "SHOW_INSTALL_PROGRESS_PAGE=$SHOW_INSTALL_PROGRESS_PAGE">>$RESPONSE_FILE
echo "SHOW_REQUIRED_CONFIG_TOOL_PAGE=$SHOW_REQUIRED_CONFIG_TOOL_PAGE">>$RESPONSE_FILE
echo "SHOW_CONFIG_TOOL_PAGE=$SHOW_CONFIG_TOOL_PAGE">>$RESPONSE_FILE
echo "SHOW_RELEASE_NOTES=$SHOW_RELEASE_NOTES">>$RESPONSE_FILE
echo "SHOW_ROOTSH_CONFIRMATION=$SHOW_ROOTSH_CONFIRMATION">>$RESPONSE_FILE
echo "SHOW_END_SESSION_PAGE=$SHOW_END_SESSION_PAGE">>$RESPONSE_FILE
echo "SHOW_EXIT_CONFIRMATION=$SHOW_EXIT_CONFIRMATION">>$RESPONSE_FILE
echo "NEXT_SESSION=$NEXT_SESSION">>$RESPONSE_FILE
echo "NEXT_SESSION_ON_FAIL=$NEXT_SESSION_ON_FAIL">>$RESPONSE_FILE
echo "DEINSTALL_LIST=$DEINSTALL_LIST">>$RESPONSE_FILE
echo "SHOW_DEINSTALL_CONFIRMATION=$SHOW_DEINSTALL_CONFIRMATION">>$RESPONSE_FILE
echo "SHOW_DEINSTALL_PROGRESS=$SHOW_DEINSTALL_PROGRESS">>$RESPONSE_FILE
echo "CLUSTER_NODES=$CLUSTER_NODES">>$RESPONSE_FILE
echo "ACCEPT_LICENSE_AGREEMENT=$ACCEPT_LICENSE_AGREEMENT">>$RESPONSE_FILE
echo "METALINK_USERNAME=$METALINK_USERNAME">>$RESPONSE_FILE
echo "PROXY_HOST=$PROXY_HOST">>$RESPONSE_FILE
echo "PROXY_PORT=$PROXY_PORT">>$RESPONSE_FILE
echo "PROXY_USER=$PROXY_USER">>$RESPONSE_FILE
echo "TOPLEVEL_COMPONENT=$TOPLEVEL_COMPONENT">>$RESPONSE_FILE
echo "SELECTED_LANGUAGES=$SELECTED_LANGUAGES">>$RESPONSE_FILE
echo "COMPONENT_LANGUAGES=$COMPONENT_LANGUAGES">>$RESPONSE_FILE
echo "TLISTEN_PORT=$TLISTEN_PORT">>$RESPONSE_FILE
echo "ENCRYPT_CHOICE=$ENCRYPT_CHOICE">>$RESPONSE_FILE
echo "MIN_CRYPT_BITS_CHOOSE=$MIN_CRYPT_BITS_CHOOSE">>$RESPONSE_FILE
echo "MAX_CRYPT_BITS_CHOOSE=$MAX_CRYPT_BITS_CHOOSE">>$RESPONSE_FILE
# echo input variables to response file
echo "ORACLE_HOME=$ORACLE_HOME" >> $RESPONSE_FILE
echo "ORACLE_HOME_NAME=$ORACLE_HOME_NAME">> $RESPONSE_FILE
echo "INSTALL_TYPE=$INSTALL_TYPE">> $RESPONSE_FILE
echo "ENABLE_TSAM_AGENT=$ENABLE_TSAM_AGENT">>$RESPONSE_FILE
echo "INSTALL_SSL=$INSTALL_SSL">>$RESPONSE_FILE
echo "LDAP_SUPPORT_SSL=$LDAP_SUPPORT_SSL ">>$RESPONSE_FILE
echo "LDAP_CONFIG=$LDAP_CONFIG">> $RESPONSE_FILE
echo "LDAP_FILTER_FILE=$LDAP_FILTER_FILE">> $RESPONSE_FILE
echo "INSTALL_SAMPLES=$INSTALL_SAMPLES">> $RESPONSE_FILE
echo "CONFIG_TLISTEN=$CONFIG_TLISTEN">> $RESPONSE_FILE
echo "TLISTEN_PASSWORD=$TLISTEN_PASSWORD">> $RESPONSE_FILE
}


runInstaller(){
    responseFile="`pwd`/$RESPONSE_FILE"
    if [ "x$INVENTORY" == "x" ]; then
        ./runInstaller -jreLoc $JAVA_HOME -responseFile $responseFile -silent -waitforcompletion -force
    else
        ./runInstaller -jreLoc $JAVA_HOME -invPtrLoc $INVENTORY -responseFile $responseFile -silent -waitforcompletion -force
    fi
}

# MAIN #

CLASSPATH=./console_install.jar:$CLASSPATH
export CLASSPATH

console_flag=0
if [ "$1" = "-console" ];then
    if [ "$#" -gt 1 ];then
      echo "too many arguments for console mode"
      exit
    fi
    console_flag=1
fi

if [ `uname -s` = "Linux" ];then
    _echo="echo -e"
else
    _echo="echo"
fi

if [ `uname -s` = "SunOS" ];then
    _awk="nawk"
else
    _awk="awk"
fi

check_java

if [ ! -x "./runInstaller" ];then
    echo "runInstaller not found"
    exit 1
fi


if [ $console_flag -eq 0 ];then
    ./runInstaller -jreLoc $JAVA_HOME $*
else
    page_introduction
    page_inventory_choose
    page_oracle_home_choose
    page_install_set_choose
    page_tsam_enable
    page_SSL_support_choice
    page_samples_installation
    page_configure_tlisten
    page_summary
    generate_response_file
    runInstaller
fi







