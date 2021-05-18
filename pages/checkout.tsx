import { useRouter } from 'next/router'
import React, { ChangeEvent, useContext, useEffect, useState } from 'react'
import CurrencyFormat from '../components/shared/CurrencyFormat'

import PageHeader from '../components/shared/PageHeader'
import AppLink from '../components/shared/AppLink'
import url from '../services/url'
import Collapse, { CollapseRenderFn } from '../components/shared/Collapse'
import Check9x7Svg from '../svg/check-9x7.svg'
import SessionContext from '../context/SessionContext'
import { IAddress, IPayment } from '../types'

import { validateAddress } from '../components/checkout/addressValidator'

import AddressInput from '../components/checkout/AddressInput'
import classNames from 'classnames'

export type RenderPaymentFn = CollapseRenderFn<HTMLLIElement, HTMLDivElement>

export default function CheckoutPage() {
  const router = useRouter()
  const { session, actions } = useContext(SessionContext)

  const address: IAddress = {
    firstName: '',
    lastName: '',
    phone: '',
    region: '',
    locality: '',
    streetAddress: '',
  }

  const [email, setEmail] = useState('')
  const [loading, setLoading] = useState(false)
  const [acceptedTerms, setAcceptedTerms] = useState(false)
  const [billingEqualsShipping, setBillingEqualsShipping] = useState(true)
  const [shippingAddress, setShippingAddress] = useState({ ...address })
  const [shippingAddressErrors, setShippingAddressErrors] = useState({})

  const [billingAddress, setBillingAddress] = useState({ ...address })
  const [billingAddressErrors, setBillingAddressErrors] = useState({})
  const [submitted, setSubmitted] = useState(false)

  const [company, setCompany] = useState('')
  const [taxCode, setTaxCode] = useState('')
  const [taxCodeError, setTaxCodeError] = useState('')

  const cart = session.checkout?.cart || { items: [] }

  const [currentPayment, setCurrentPayment] = useState('cod')

  const handlePaymentChange = (event: ChangeEvent<HTMLInputElement>) => {
    if (event.target.checked) {
      setCurrentPayment(event.target.value)
    }
  }
  const handleEmailChange = (email: string) => {
    setShippingAddressErrors(prevState => {
      return { ...prevState, email: null }
    })
    setEmail(email)
  }

  if (cart.items.length < 1) {
    return null
  }

  const validateInputFields = async () => {
    setSubmitted(true)
    const shippingAddressErrors = validateAddress(shippingAddress)

    if (!email) {
      // TODO valid email not only required
      shippingAddressErrors.email = 'Required'
    }

    let billingAddressErrors = {}

    if (!billingEqualsShipping) {
      billingAddressErrors = validateAddress(billingAddress)

      if (company && !taxCode) {
        setTaxCodeError('Required')
      }
    } else {
      setBillingAddressErrors({})
    }

    if (
      Object.keys(shippingAddressErrors).length ||
      Object.keys(billingAddressErrors).length ||
      !acceptedTerms
    ) {
      setShippingAddressErrors(shippingAddressErrors)
      setBillingAddressErrors(billingAddressErrors)
      return false
    }

    try {
      setLoading(true)

      if (company && taxCode) {
        billingAddress.company = company
        billingAddress.taxCode = taxCode
      }

      await actions.completeCheckout({
        email,
        shippingMethodId: session.availableShippingMethods[0].id,
        billingAddress: billingEqualsShipping ? shippingAddress : billingAddress,
        shippingAddress,
        checkoutId: session.checkout.id,
      })
    } finally {
      setLoading(false)
    }

    router.push({
      pathname: '/success',
    })
  }

  const totals: any = []

  // const totals = (cart.totals || []).map((total, index) => (
  //   <tr key={index}>
  //     <th>{total.title}</th>
  //     <td>
  //       <CurrencyFormat value={total.price} />
  //     </td>
  //   </tr>
  // ))

  const cartItems = cart.items.map(item => (
    <tr key={item.id}>
      <td>{`${item.product.name} × ${item.quantity}`}</td>
      <td>
        <CurrencyFormat value={item.total} />
      </td>
    </tr>
  ))

  const cartTable = (
    <table className="checkout__totals">
      <thead className="checkout__totals-header">
        <tr>
          <th>Product</th>
          <th>Total</th>
        </tr>
      </thead>
      <tbody className="checkout__totals-products">{cartItems}</tbody>
      {totals.length > 0 && (
        <tbody className="checkout__totals-subtotals">
          <tr>
            <th>Subtotal</th>
            <td>
              <CurrencyFormat value={cart.subtotal} />
            </td>
          </tr>
          {totals}
        </tbody>
      )}
      <tfoot className="checkout__totals-footer">
        <tr>
          <th>Total</th>
          <td>{/*<CurrencyFormat value={cart.total} />*/}</td>
        </tr>
      </tfoot>
    </table>
  )

  const paymentMethods: IPayment[] = [
    { key: 'cod', title: 'Ramburs', description: 'Plată ramburs la curier' },
  ]

  const payments = paymentMethods.map(payment => {
    const renderPayment: RenderPaymentFn = ({ setItemRef, setContentRef }) => (
      <li className="payment-methods__item" ref={setItemRef}>
        <label className="payment-methods__item-header">
          <span className="payment-methods__item-radio input-radio">
            <span className="input-radio__body">
              <input
                type="radio"
                className="input-radio__input"
                name="checkout_payment_method"
                value={payment.key}
                checked={currentPayment === payment.key}
                onChange={handlePaymentChange}
              />
              <span className="input-radio__circle" />
            </span>
          </span>
          <span className="payment-methods__item-title">{payment.title}</span>
        </label>
        <div className="payment-methods__item-container" ref={setContentRef}>
          <div className="payment-methods__item-description text-muted">{payment.description}</div>
        </div>
      </li>
    )

    return (
      <Collapse
        key={payment.key}
        open={currentPayment === payment.key}
        toggleClass="payment-methods__item--active"
        render={renderPayment}
      />
    )
  })

  const breadcrumb = [
    { title: 'Home', url: url.home() },
    { title: 'Shopping Cart', url: url.cart() },
    { title: 'Checkout', url: '' },
  ]

  return (
    <>
      {/*<Head>*/}
      {/*  <title>cablu.io checkout</title>*/}
      {/*</Head>*/}

      <PageHeader header="Checkout" breadcrumb={breadcrumb} />

      <div className="checkout block">
        <div className="container">
          <div className="row">
            {/*<div className="col-12 mb-3">*/}
            {/*  <div className="alert alert-primary alert-lg">*/}
            {/*    Returning customer?{' '}*/}
            {/*    <AppLink href={url.accountSignIn()}>Click here to login</AppLink>*/}
            {/*  </div>*/}
            {/*</div>*/}

            <div className="col-12 col-lg-6 col-xl-7">
              <div className="card mb-lg-0">
                <div className="card-body">
                  <h3 className="card-title">Shipping Details</h3>

                  <AddressInput
                    address={shippingAddress}
                    setAddress={setShippingAddress}
                    errors={shippingAddressErrors}
                    setAddressErrors={setShippingAddressErrors}
                    includeEmail={true}
                    email={email}
                    setEmail={handleEmailChange}
                  />
                </div>

                <div className="card-divider" />

                <div className="card-body">
                  <h3 className="card-title">Billing details</h3>

                  <div className="form-group">
                    <div
                      className="form-check"
                      onClick={e => {
                        setBillingEqualsShipping(!billingEqualsShipping)
                      }}
                    >
                      <span className="form-check-input input-check">
                        <span className="input-check__body">
                          <input
                            checked={!billingEqualsShipping}
                            onChange={() => setBillingEqualsShipping(!billingEqualsShipping)}
                            className="input-check__input"
                            type="checkbox"
                            id="checkout-create-account"
                          />
                          <span className="input-check__box" />
                          <Check9x7Svg className="input-check__icon" />
                        </span>
                      </span>
                      <label
                        className="form-check-label"
                        htmlFor="checkout-billing-same-as-shipping"
                      >
                        Bill to a different address?
                      </label>
                    </div>
                  </div>

                  {!billingEqualsShipping ? (
                    <>
                      <AddressInput
                        address={billingAddress}
                        setAddress={setBillingAddress}
                        errors={billingAddressErrors}
                        setAddressErrors={setBillingAddressErrors}
                        includeEmail={false}
                      />

                      <div className="form-row">
                        <div className="form-group col-md-6">
                          <label htmlFor="checkout-checkout-company">Company</label>
                          <input
                            type="text"
                            value={company}
                            onChange={e => setCompany(e.target.value)}
                            className="form-control"
                            id="checkout-company"
                            placeholder="Company"
                          />
                        </div>

                        <div className="form-group col-md-6">
                          <label htmlFor="checkout-tax-code">Tax Code</label>
                          <input
                            type="text"
                            className={classNames('form-control', {
                              'is-invalid': taxCodeError,
                            })}
                            value={taxCode}
                            onChange={e => setTaxCode(e.target.value)}
                            id="checkout-tax-code"
                            placeholder="Tax Code"
                          />
                          <div className="invalid-feedback">{taxCodeError}</div>
                        </div>
                      </div>
                    </>
                  ) : (
                    <div>We will use the shipping address for billing details</div>
                  )}
                </div>
              </div>
            </div>

            <div className="col-12 col-lg-6 col-xl-5 mt-4 mt-lg-0">
              <div className="card mb-0">
                <div className="card-body">
                  <h3 className="card-title">Your Order</h3>

                  {cartTable}

                  <div className="payment-methods">
                    <ul className="payment-methods__list">{payments}</ul>
                  </div>

                  <div className="checkout__agree form-group">
                    <div className="form-check">
                      <span
                        className={classNames([
                          'form-check-input input-check',
                          submitted && !acceptedTerms ? 'is-invalid' : '',
                        ])}
                      >
                        <span className="input-check__body">
                          <input
                            onChange={() => {
                              setAcceptedTerms(!acceptedTerms)
                            }}
                            className="input-check__input"
                            type="checkbox"
                            id="checkout-terms"
                          />
                          <span className="input-check__box" />
                          <Check9x7Svg className="input-check__icon" />
                        </span>
                      </span>
                      <label className="form-check-label" htmlFor="checkout-terms">
                        I have read and agree to the website
                        <AppLink href={url.terms()}> {' terms and conditions'}</AppLink>*
                      </label>
                      <div className="invalid-feedback">Required</div>
                    </div>
                  </div>

                  <button
                    type="submit"
                    className={classNames([
                      'btn btn-primary',
                      'btn-xl',
                      'btn-block',
                      loading ? 'btn-loading' : '',
                    ])}
                    onClick={validateInputFields}
                  >
                    Place Order
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  )
}
