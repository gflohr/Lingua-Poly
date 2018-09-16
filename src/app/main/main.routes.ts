import { StartComponent } from './components/start/start.component';
import { LegalDisclosureComponent } 
    from './components/legal-disclosure/legal-disclosure.component';

export const mainRoutes = [
    { path: '', component: StartComponent },
    { path: 'legal-disclosure', component: LegalDisclosureComponent },
];
