import { Routes } from '@angular/router';
import { AppComponent } from './app.component';

export const appRoutes: Routes = [
		{
			path: ':lingua',
			data: { title: 'lingua selector'},
			component: AppComponent,
			loadChildren: () => import('./main/main.module').then(m => m.MainModule)
		},
		{
			path: '',
			data: { title: 'lingua redirect' },
			pathMatch: 'full',
			// FIXME! Redirect to controller that does the content negotiation.
			redirectTo: '/en/start'
		},
];
