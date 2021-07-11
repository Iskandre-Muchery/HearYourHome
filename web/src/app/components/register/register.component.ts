import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { AuthentificationService } from 'src/app/services/authentification/authentification.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent implements OnInit {

  registerForm = new FormGroup({
    email: new FormControl('', Validators.required),
    password: new FormControl('', Validators.required),
  });

  private subscriptions: Subscription[] = [];

  constructor(
    private authentificationService: AuthentificationService,
    private router: Router,
  ) {

  }

  ngOnInit(): void {
  }

  register(): void {
    if (this.registerForm.valid) {
      this.subscriptions.push(
        this.authentificationService.sendRegister(this.registerForm.value).subscribe(
          data => {
            this.router.navigate(['/dashboard']);
          },
          error => console.error(error)
        )
      );
    }
  }

  goToLogin(): void {
    this.router.navigate(['/login']);
  }

}
