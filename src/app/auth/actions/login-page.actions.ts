import { createAction, props } from '@ngrx/store';
import { UserLogin } from '../../core/openapi/lingua-poly';

export const login = createAction(
	'[Login page] Login',
	props<{ credentials: UserLogin }>()
);
