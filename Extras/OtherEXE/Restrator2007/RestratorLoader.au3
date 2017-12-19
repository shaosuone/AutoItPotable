#NoTrayIcon
;注册信息
RegWrite('HKEY_CURRENT_USER\Software\Bomers\Restorator\Registration','Name','REG_SZ','虫子樱桃')
RegWrite('HKEY_CURRENT_USER\Software\Bomers\Restorator\Registration','Password','REG_SZ','BHKkVHci22chpT9i-D8ssq1hDhtDW8PbpClCxAZI68SiKGJ0Rb3zNymwqivyD805AZiywoKunQ4tir87QHFTvEZT7ye6M2FLyj5ieY6AP1E+v4AZaTOmZMdar2NRF47YzbQa8Fb5mVkyEIH-4eeZQKs0mImoht00LkBnRQdxnqI')
RegWrite('HKEY_CURRENT_USER\Software\Bomers\Restorator\Registration','Type','REG_SZ','Regular')
;添加工具
RegWrite('HKEY_CURRENT_USER\SOFTWARE\Bomers\Restorator\Restorator\Tools\0','Name','REG_SZ','ResHacker资源修改工具')
RegWrite('HKEY_CURRENT_USER\SOFTWARE\Bomers\Restorator\Restorator\Tools\0','Path','REG_SZ','"'&StringRegExpReplace(@ScriptDir, '\\[^\\]*$', '')&'\ResHacker.exe"')
RunWait(@ScriptDir&'\Restorator.exe')
RegDelete('HKEY_CLASSES_ROOT\BomeRst.acm')
RegDelete('HKEY_CLASSES_ROOT\BomeRst.ax')
RegDelete('HKEY_CLASSES_ROOT\BomeRst.bpl')
RegDelete('HKEY_CLASSES_ROOT\BomeRst.cnv')
RegDelete('HKEY_CLASSES_ROOT\BomeRst.dpl')
RegDelete('HKEY_CLASSES_ROOT\BomeRst.flt')
RegDelete('HKEY_CLASSES_ROOT\BomeRst.rc')
RegDelete('HKEY_CLASSES_ROOT\BomeRst.tlb')
RegDelete('HKEY_CLASSES_ROOT\BomeRst.tsp')
RegDelete('HKEY_CLASSES_ROOT\BomeRst.res')
RegDelete('HKEY_CLASSES_ROOT\BomeRst.wpc')
RegDelete('HKEY_CURRENT_USER\Software\Bomers')
RegDelete('HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU\1\2\17\0\1')

