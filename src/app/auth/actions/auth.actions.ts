import { createAction, props } from '@ngrx/store';
import { SocialUser } from 'angularx-social-login';

export const logout = createAction('[Auth] Logout');
export const logoutConfirmation = createAction('[Auth] Logout Confirmation');
export const logoutConfirmationDismiss = createAction(
	'[Auth] Logout Confirmation Dismiss'
);
export const socialLogin = createAction(
	'[Social Login] AuthState Change',
	props<{ user: SocialUser }>()
);
