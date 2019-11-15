$Win32 = Add-Type -Namespace "EnvVar.Import" -Name "Win32" -PassThru -MemberDefinition @"
            [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
            public static extern IntPtr SendMessageTimeout(
                IntPtr hWnd,
                uint Msg,
                UIntPtr wParam,
                string lParam,
                uint fuFlags,
                uint uTimeout,
                out UIntPtr lpdwResult
            );

            [DllImport("kernel32.dll")]
            public static extern uint GetLastError();
"@ -ErrorAction Continue
function Update-EnvironmentVariableSettings {
    param (
    )

    begin {
    }

    process {
        $HWND_BROADCAST = [IntPtr] 0xffff
        $WM_SETTINGCHANGE = 0x1a
        $result = [UIntPtr]::Zero

        $ret = $Win32::SendMessageTimeout(
            $HWND_BROADCAST,
            $WM_SETTINGCHANGE,
            [UIntPtr]::Zero,
            "Environment",
            2,
            5000,
            [ref] $result
        )
        if ($ret -eq 0) {
            $errorcode = $Win32::GetLastError($ret)
            Write-Error "failed to update environment setting (error code: $errorcode)"
        }
    }

    end {
    }
}