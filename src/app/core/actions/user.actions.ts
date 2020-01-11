import { createAction, props } from '@ngrx/store';
import { Profile } from '../openapi/lingua-poly';

export const idleTimeout = createAction('[User] Idle Timeout');
export const requestProfile = createAction('[Navigation] Request Profile');
export const setProfile = createAction(
	'[Profile Page] Set Profile',
	props<{ payload: Profile}>()
);
