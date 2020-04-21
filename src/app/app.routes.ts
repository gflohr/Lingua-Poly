import { Routes } from '@angular/router';
import { AppComponent } from './app.component';
import { LinguaSelectorComponent } from './lingua/components/lingua-selector/lingua-selector.component';

export const appRoutes: Routes = [
		{
			path: ':lingua',
			data: { title: 'lingua selector'},
			component: AppComponent,
			loadChildren: () => import('./route-container/route-container.module').then(m => m.RouteContainerModule)
		},
		{
			path: '',
			data: { title: 'lingua redirect' },
			component: LinguaSelectorComponent,
		},
];
