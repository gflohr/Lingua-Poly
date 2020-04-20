import { Routes } from '@angular/router';

export const routes: Routes = [
	{
		path: 'main',
		loadChildren: () => import('../main/main.module').then(m => m.MainModule)
	},
	{
		path: 'auth',
		loadChildren: () => import('../auth/auth.module').then(m => m.AuthModule)
	},
	{
		path: 'user',
		loadChildren: () => import('../user/user.module').then(m => m.UserModule)
	},
]
