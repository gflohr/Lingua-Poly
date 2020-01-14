import { createAction, props } from '@ngrx/store';
import { UserLogin } from '../../core/openapi/lingua-poly';

export const login = createAction(
	'[Login page] Login',
	props<{ credentials: UserLogin }>()
);
export const socialLogin = createAction(
	'[Login page] Social Login',
	props<{ provider: String }>()
);
