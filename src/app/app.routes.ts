import { Routes } from '@angular/router';
import { AppComponent } from './app.component';

export const appRoutes: Routes = [
		{ path: ':lingua', component: AppComponent, loadChildren: () => import('./main/main.module').then(m => m.MainModule) },
		{ path: '', pathMatch: 'full', redirectTo: '/en' }
];
