import { createAction, props } from '@ngrx/store';
import { SocialUser } from 'angularx-social-login';
import { OAuth2Login } from '../../core/openapi/lingua-poly';

export const logout = createAction('[Auth] Logout');
export const logoutConfirmation = createAction('[Auth] Logout Confirmation');
export const logoutConfirmationDismiss = createAction(
	'[Auth] Logout Confirmation Dismiss'
);
export const socialLogin = createAction(
	'[Social Login] Login',
	props<{
		socialUser: SocialUser,
		provider: OAuth2Login.ProviderEnum
	}>()
);
export const socialLogout = createAction('[Social Login] Logout');
