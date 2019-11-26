import { createAction, props } from '@ngrx/store';
import { User } from '../../core/openapi/lingua-poly';

export const profileSuccess = createAction(
	'[User API] Profile Success',
	props<{ user: User }>()
);

export const profileFailure = createAction(
	'[User API] Profile Failure',
	props<{ error: any }>()
);
