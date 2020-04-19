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

export const changePasswordFailure = createAction(
	'[User API] Change Password Failure',
	props<{ error: any }>()
);

export const changePasswordWithTokenSuccess = createAction(
	'[User API] Change Password with Token Success',
	props<{ user: User }>()
)

export const deleteAccountSuccess = createAction(
	'[User API] Delete Account Success'
);

export const deleteAccountFailure = createAction(
	'[User API] Delete Account Failure',
	props<{ error: any }>()
);
