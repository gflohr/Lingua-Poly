import { Component, Input, OnInit } from '@angular/core';
import { NgbActiveModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-logout-confirmation',
  templateUrl: './logout-confirmation.component.html',
  styleUrls: ['./logout-confirmation.component.css']
})
export class LogoutConfirmationComponent implements OnInit {
	constructor(
		public activeModal: NgbActiveModal
	) { }

	ngOnInit() {
	}

	closeModal() {
		this.activeModal.close('Modal closed');
	}
}
