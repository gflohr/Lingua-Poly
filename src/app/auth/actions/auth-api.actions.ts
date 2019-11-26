import { createAction, props } from '@ngrx/store';
import { User } from '../../core/openapi/lingua-poly';

export const loginSuccess = createAction(
	'[Auth API] login success',
	props<{ user: User }>()
);

export const loginFailure = createAction(
	'[Auth API] login failure',
	props<{ error: Error }>()
);
