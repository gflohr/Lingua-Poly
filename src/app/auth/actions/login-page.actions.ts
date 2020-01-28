import { createAction, props } from '@ngrx/store';
import { UserLogin } from '../../core/openapi/lingua-poly';

export const login = createAction(
	'[Login page] Login',
	props<{ credentials: UserLogin }>()
);
export const socialLoginRequest = createAction(
	'[Login page] Social Login Request',
	props<{ provider: string }>()
);
