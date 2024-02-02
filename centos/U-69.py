#!/usr/bin/python3
import os
import stat

def check_nfs_config_permissions():
    results = {
        "분류": "서비스 관리",
        "코드": "U-69",
        "위험도": "중",
        "진단 항목": "NFS 설정파일 접근권한",
        "진단 결과": "양호",  # Assume "Good" until proven otherwise
        "현황": "NFS 접근제어 설정파일의 소유자가 root이고, 권한이 644 이하입니다.",
        "대응방안": "NFS 설정파일의 소유자를 root으로 설정하고, 권한을 644 이하로 설정"
    }

    exports_file = '/etc/exports'
    if os.path.exists(exports_file):
        file_stat = os.stat(exports_file)
        mode = file_stat.st_mode
        owner_uid = file_stat.st_uid

        # Check if owner is root
        if owner_uid != 0:
            results["진단 결과"] = "취약"
            results["현황"] = "/etc/exports 파일의 소유자(owner)가 root가 아닙니다."
            return results

        # Check file permissions
        permissions = stat.S_IMODE(mode)
        if permissions > 0o644:
            results["진단 결과"] = "취약"
            results["현황"] = "/etc/exports 파일의 권한이 644보다 큽니다."
            return results

        # Detailed permission check (optional, as covered by the > 644 check above)
        if not all([permissions & stat.S_IRUSR, permissions & stat.S_IWUSR, not permissions & stat.S_IXUSR,
                    permissions & stat.S_IRGRP, not permissions & stat.S_IWGRP, not permissions & stat.S_IXGRP,
                    not permissions & stat.S_IROTH, not permissions & stat.S_IWOTH, not permissions & stat.S_IXOTH]):
            results["진단 결과"] = "취약"
            results["현황"] = "/etc/exports 파일의 권한 설정이 부적절합니다."
            return results
    else:
        results["진단 결과"] = "N/A"
        results["현황"] = "/etc/exports 파일이 없습니다."

    return results

def main():
    nfs_config_permission_check_results = check_nfs_config_permissions()
    print(nfs_config_permission_check_results)

if __name__ == "__main__":
    main()
