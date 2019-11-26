import { createAction, props } from '@ngrx/store';
import { User } from '../../core/openapi/lingua-poly';

export const loginSuccess = createAction(
	'[Auth API] Login Success',
	props<{ user: User }>()
);

export const loginFailure = createAction(
	'[Auth API] Login Failure',
	props<{ error: any }>()
);

export const loginRedirect = createAction('[Auth/API] Login Redirect');
