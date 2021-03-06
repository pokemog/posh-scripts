# ADS_USER_FLAG_ENUM Enumeration
# http://msdn.microsoft.com/en-us/library/aa772300(VS.85).aspx
$ADS_UF_SCRIPT                                   = 1         # 0x1
$ADS_UF_ACCOUNTDISABLE                           = 2         # 0x2
$ADS_UF_HOMEDIR_REQUIRED                         = 8         # 0x8
$ADS_UF_LOCKOUT                                  = 16        # 0x10
$ADS_UF_PASSWD_NOTREQD                           = 32        # 0x20
$ADS_UF_PASSWD_CANT_CHANGE                       = 64        # 0x40
$ADS_UF_ENCRYPTED_TEXT_PASSWORD_ALLOWED          = 128       # 0x80
$ADS_UF_TEMP_DUPLICATE_ACCOUNT                   = 256       # 0x100
$ADS_UF_NORMAL_ACCOUNT                           = 512       # 0x200
$ADS_UF_INTERDOMAIN_TRUST_ACCOUNT                = 2048      # 0x800
$ADS_UF_WORKSTATION_TRUST_ACCOUNT                = 4096      # 0x1000
$ADS_UF_SERVER_TRUST_ACCOUNT                     = 8192      # 0x2000
$ADS_UF_DONT_EXPIRE_PASSWD                       = 65536     # 0x10000
$ADS_UF_MNS_LOGON_ACCOUNT                        = 131072    # 0x20000
$ADS_UF_SMARTCARD_REQUIRED                       = 262144    # 0x40000
$ADS_UF_TRUSTED_FOR_DELEGATION                   = 524288    # 0x80000
$ADS_UF_NOT_DELEGATED                            = 1048576   # 0x100000
$ADS_UF_USE_DES_KEY_ONLY                         = 2097152   # 0x200000
$ADS_UF_DONT_REQUIRE_PREAUTH                     = 4194304   # 0x400000
$ADS_UF_PASSWORD_EXPIRED                         = 8388608   # 0x800000
$ADS_UF_TRUSTED_TO_AUTHENTICATE_FOR_DELEGATION   = 16777216  # 0x1000000

Function AddUserFlag()
{
    $userName = $args[0]
    $flag = $args[1]
    $u = [adsi]"WinNT://$env:computername/$userName,user"
    $u.invokeSet("userFlags", ($u.userFlags[0] -BOR $flag))
    $u.commitChanges()
}

Function RemoveUserFlag()
{
    $userName = $args[0]
    $flag = $args[1]
    $u = [adsi]"WinNT://$env:computername/$userName,user"
    if ($u.UserFlags[0] -BAND $flag)
    {
        $u.invokeSet("userFlags", ($u.userFlags[0] -BXOR $flag))
        $u.commitChanges()
    }
}

$computer = [ADSI]"WinNT://$env:computername,computer"
$Users = $computer.psbase.Children |
    Where-Object {$_.psbase.schemaclassname -eq 'user'}
foreach ($user in $Users.psbase.syncroot)
{
    If ($user.name -eq "Administrator")
    {
        AddUserFlag $user.name $ADS_UF_DONT_EXPIRE_PASSWD
    }
    # Else
    # {
    #     RemoveUserFlag $user.name $ADS_UF_DONT_EXPIRE_PASSWD
    # }
}