import { createAction, props } from '@ngrx/store';
import { Profile, PasswordChange, PasswordReset } from '../openapi/lingua-poly';

export const idleTimeout = createAction('[User] Idle Timeout');
export const requestProfile = createAction('[Navigation] Request Profile');

export const setProfile = createAction(
	'[Profile Page] Set Profile',
	props<{ payload: Profile}>()
);

export const changePassword = createAction(
	'[Change Password Page] Change Password',
	props<{ payload: PasswordChange}>()
);

export const changePasswordWithToken = createAction(
	'[Change Password with Token Page] Change Password',
	props<{ payload: PasswordChange }>()
);

export const resetPasswordRequest = createAction(
	'[Reset Password Page] Reset Password',
	props<{ payload: PasswordReset }>()
);
