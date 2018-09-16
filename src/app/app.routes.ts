import { RouterModule, Routes } from '@angular/router';
import { AppComponent } from './app.component'

export const appRoutes: Routes = [
    { path: ":lingua", component: AppComponent, loadChildren: 'app/main/main.module#MainModule' },
    { path: "", pathMatch: "full", redirectTo: "/en" }
];
