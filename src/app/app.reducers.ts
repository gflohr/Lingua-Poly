import { UserStateRecord, UserState } from './user/states/user.state';
import { ActionReducerMap, MetaReducer } from '@ngrx/store';
import { AppState } from './app.interfaces';
import { userReducer } from './user/reducers/user.reducer';

export const initialState = {
	user: new UserStateRecord() as UserState
};

export const reducers: ActionReducerMap<AppState> = {
	user: userReducer
};

export const metaReducers: MetaReducer<AppState>[] = [];
