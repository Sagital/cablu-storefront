export type SubscriptionFn = (area: HTMLElement | null) => void

class DepartmentsService {
  private areaState: HTMLElement | null = null

  private subscriber: SubscriptionFn | null = null

  set area(value: HTMLElement | null) {
    if (this.areaState === value) {
      return
    }

    this.areaState = value

    if (this.subscriber) {
      this.subscriber(this.area)
    }
  }

  get area() {
    return this.areaState
  }

  subscribe(fn: SubscriptionFn) {
    this.subscriber = fn

    return () => {
      this.subscriber = null
    }
  }
}

const departmentsService = new DepartmentsService()

export default departmentsService
