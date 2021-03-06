### resource type below will change pam file provided as a resource title 
define pam_policies::common_params ( $pam_file_name = $title, ) {

 augeas {
	"${pam_file_name}_tally2_deny_failed_auth_attempts_insert":
		context => "/files/etc/pam.d/${pam_file_name}",
		changes => [
			"ins 01 before *[type='auth' and module='pam_env.so']",
			"set 01/type auth",
			"set 01/control required",
			"set 01/module pam_tally2.so",
			"set 01/argument[1] deny=5",
			"set 01/argument[2] onerr=fail",
			"set 01/argument[3] unlock_time=600",
		],
		onlyif  => "match *[type='auth'][control='required'][module='pam_tally2.so'] size == 0";

	"${pam_file_name}_tally2_deny_failed_auth_attempts_params":
		context => "/files/etc/pam.d/${pam_file_name}",
		changes => [
			"set *[type='auth'][module='pam_tally2.so']/control required",
			"rm *[type='auth'][module='pam_tally2.so']/argument",
			"set *[type='auth'][module='pam_tally2.so']/argument[1] deny=5",
			"set *[type='auth'][module='pam_tally2.so']/argument[2] onerr=fail",
			"set *[type='auth'][module='pam_tally2.so']/argument[3] unlock_time=600",
		];

	"${pam_file_name}_tally2_account":
		context => "/files/etc/pam.d/${pam_file_name}",
		changes => [
			"ins 01 before *[type='account' and module='pam_unix.so']",
			"set 01/type account",
			"set 01/control required",
			"set 01/module pam_tally2.so",
		],
		onlyif  => "match *[type='account'][control='required'][module='pam_tally2.so'] size == 0";

	"${pam_file_name}_passwd_history":
		context => "/files/etc/pam.d/${pam_file_name}",
		changes => "set *[type = 'password'][module = 'pam_unix.so']/argument[.=~regexp('remember.*')] remember=12",
		onlyif  => "match *[type='password'][module='pam_unix.so']/argument[.='remember=12'] size == 0";

	"${pam_file_name}_no_empty_passwd":
		context => "/files/etc/pam.d/${pam_file_name}",
		changes => [
			"rm *[type = 'password'][module = 'pam_unix.so']/argument[.= 'nullok']",
			"rm *[type = 'auth'][module = 'pam_unix.so']/argument[.= 'nullok']",
		],
		onlyif  => "match *[type='password'][module='pam_unix.so']/argument[.='nullok'] size == 1";

	"${pam_file_name}_passwd_hashing_algorithm":
		context => "/files/etc/pam.d/${pam_file_name}",
		changes => [
			"set *[type = 'password'][module = 'pam_unix.so']/argument[.=~regexp('sha512')] sha512",
			"rm *[type = 'password'][module = 'pam_unix.so']/argument[.= 'md5']",
		],
		onlyif  => "match *[type='password'][module='pam_unix.so']/argument[.='sha512'] size == 0";

	} # end augeas all linux common pam parameters

### password quality parameters 

	       augeas { "${pam_file_name}_cracklib_passwd_quality_params":
		       context => "/files/etc/pam.d/${pam_file_name}",
		       changes => [
			     "set *[type='password'][module='pam_cracklib.so']/control required",
			     "rm *[type='password'][module='pam_cracklib.so']/argument",
			     "set *[type='password'][module='pam_cracklib.so']/argument[1] try_first_pass",
			     "set *[type='password'][module='pam_cracklib.so']/argument[2] retry=3",
			     "set *[type='password'][module='pam_cracklib.so']/argument[3] minlen=8",
			     "set *[type='password'][module='pam_cracklib.so']/argument[4] maxrepeat=2",
			     "set *[type='password'][module='pam_cracklib.so']/argument[5] dcredit=-1",
			     "set *[type='password'][module='pam_cracklib.so']/argument[6] ucredit=-1",
			     "set *[type='password'][module='pam_cracklib.so']/argument[7] ocredit=-1",
			     "set *[type='password'][module='pam_cracklib.so']/argument[8] lcredit=-1",
			     "set *[type='password'][module='pam_cracklib.so']/argument[9] difok=1",
			     "set *[type='password'][module='pam_cracklib.so']/argument[10] reject_username",
		       ],
         }

} # end define pam_policies:common_params
