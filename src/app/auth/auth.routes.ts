import { LoginComponent } from './components/login/login.component';
import { RegistrationComponent } from './components/registration/registration.component';
import { RegistrationReceivedComponent } from './components/registration-received/registration-received.component';

export const authRoutes = [
    { path: 'login', component: LoginComponent },
    { path: 'registration', component: RegistrationComponent },
    { path: 'registration-received', component: RegistrationReceivedComponent }
];
