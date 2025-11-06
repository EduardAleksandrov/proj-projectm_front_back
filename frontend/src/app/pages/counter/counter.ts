import { Component } from '@angular/core';
import { Store } from '@ngrx/store';
import { increment, decrement, reset } from '../../store/counter.actions';
import { CounterState } from '../../store/counter.reducer';
import { Observable } from 'rxjs';
import { selectCount } from '../../store/counter.selectors'; // Import the selector
import { AsyncPipe } from '@angular/common'; // Import AsyncPipe



@Component({
  selector: 'app-counter',
  imports: [AsyncPipe],
  templateUrl: './counter.html',
  styleUrl: './counter.scss',
})
export class Counter {
  count$: Observable<number>;

  constructor(private store: Store<{ counter: CounterState }>) {
    this.count$ = this.store.select(selectCount); // Using a selector
    // Or directly: this.count$ = this.store.select(state => state.counter.count);
    // this.count$ = this.store.select(state => state.counter.count);
  }

  increment() {
    this.store.dispatch(increment());
  }

  decrement() {
    this.store.dispatch(decrement());
  }

  reset() {
    this.store.dispatch(reset({ value: 0 }));
  }
}
