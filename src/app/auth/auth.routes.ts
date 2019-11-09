import { LoginComponent } from './components/login/login.component';
import { RegistrationComponent } from './components/registration/registration.component';

export const authRoutes = [
    { path: 'login', component: LoginComponent },
    { path: 'registration', component: RegistrationComponent }
];
