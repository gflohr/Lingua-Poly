import { createAction, props } from '@ngrx/store';
import { UserLogin, OAuth2Login } from '../../core/openapi/lingua-poly';

export const login = createAction(
	'[Login page] Login',
	props<{ credentials: UserLogin }>()
);
export const socialLoginRequest = createAction(
	'[Login page] Social Login Request',
	props<{ provider: OAuth2Login.ProviderEnum }>()
);
