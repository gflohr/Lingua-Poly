import { createAction, props } from '@ngrx/store';
import { User, OAuth2Login } from '../../core/openapi/lingua-poly';

export const loginSuccess = createAction(
	'[Auth API] Login Success',
	props<{ user: User, provider: OAuth2Login.ProviderEnum | null }>()
);

export const loginFailure = createAction(
	'[Auth API] Login Failure',
	props<{ error: any }>()
);

export const logoutSuccess = createAction('[Auth API] Logout Success');

export const logoutFailure = createAction(
	'[Auth API] Logout Failure',
	props<{ error: any }>()
);
