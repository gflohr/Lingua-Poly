import { StartComponent } from './components/start/start.component';
import { LegalDisclosureComponent } 
    from './components/legal-disclosure/legal-disclosure.component';
import { DisclaimerComponent } 
    from './components/disclaimer/disclaimer.component';
import { DataPrivacyComponent } 
    from './components/data-privacy/data-privacy.component';

export const mainRoutes = [
    { path: '', component: StartComponent },
    { path: 'legal-disclosure', component: LegalDisclosureComponent },
    { path: 'disclaimer', component: DisclaimerComponent },
    { path: 'data-privacy', component: DataPrivacyComponent },
    { path: ':lingua/mytest', component:  StartComponent },
];
