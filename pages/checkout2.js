import React, { useContext, useState } from 'react'

import { useRouter } from 'next/router'

import {
  Button,
  Card,
  CardContent,
  CardHeader,
  Checkbox,
  Container,
  Divider,
  FormControlLabel,
  FormGroup,
  Grid,
  Hidden,
  Radio,
  RadioGroup,
  Typography,
} from '@material-ui/core'

import { Vbox } from 'react-storefront/Box'

import { makeStyles } from '@material-ui/core/styles'
import Row from 'react-storefront/Row'
import { Hbox } from 'react-storefront/Box'
import Spacer from 'react-storefront/Spacer'
import SessionContext from '../context/SessionContext'

import Link from 'react-storefront/link/Link'
import clsx from 'clsx'
import get from 'lodash/get'
import PaymentDetails from '../components/checkout/PaymentDetails'
import AddressInput from '../components/checkout/AddressInput'
import { validateAddress } from '../components/checkout/addressValidator'

const useStyles = makeStyles(theme => ({
  main: {
    display: 'flex',
    alignItems: 'center',
    flexDirection: 'column',
    textAlign: 'center',
    margin: theme.spacing(10, 0, 0, 0),
  },
  checkoutPanel: {
    backgroundColor: theme.palette.grey['200'],
    borderRadius: theme.shape.borderRadius,
    padding: `${theme.spacing(2)}px`,
  },
}))

export default function Checkout2() {
  const classes = useStyles()

  const router = useRouter()

  const address = {
    firstName: '',
    lastName: '',
    phone: '',
    email: '',
    region: '',
    locality: '',
    streetAddress: '',
  }

  const [shippingMethodId, setShippingMethodId] = useState('')
  const [paymentMethodId, setPaymentMethodId] = useState('')
  const [email, setEmail] = useState('')
  const [shippingAddress, setShippingAddress] = useState({ ...address })
  const [shippingAddressErrors, setShippingAddressErrors] = useState({})

  const [billingAddress, setBillingAddress] = useState({ ...address })
  const [billingAddressErrors, setBillingAddressErrors] = useState({})
  const [copyFromShippingFlag, setCopyFromShippingFlag] = useState(false)
  const [sessionLoaded, setSessionLoaded] = useState(false)

  const { session, actions } = useContext(SessionContext)

  const checkoutId = get(session, 'cart.id')
  const items = get(session, 'cart.items')

  const availableShippingMethods = get(session, 'availableShippingMethods')
  const availablePaymentMethods = get(session, 'availablePaymentMethods')

  // want to execute it just once when the session is loaded
  if (!session.loading && !sessionLoaded) {
    // TODO what happens if the session does not have this data ?
    if (session.email) {
      setEmail(session.email)
    }

    if (session.shippingAddress) {
      setShippingAddress(session.shippingAddress)
    }

    if (session.billingAddress) {
      setBillingAddress(session.billingAddress)
    }
    if (session.shippingMethodId) {
      setShippingMethodId(session.shippingMethodId)
    } else {
      setShippingMethodId(availableShippingMethods[0].id)
    }

    if (session.paymentMethodId) {
      setPaymentMethodId(session.paymentMethodId)
    } else {
      setPaymentMethodId(availablePaymentMethods[0].id)
    }

    setSessionLoaded(true)
  }

  const validateInputFields = async () => {
    const shippingAddressErrors = validateAddress(shippingAddress)

    if (!email) {
      // TODO valid email not only required
      shippingAddressErrors.email = 'Required'
    }

    const billingAddressErrors = validateAddress(billingAddress)

    if (Object.keys(shippingAddressErrors).length || Object.keys(billingAddressErrors).length) {
      setShippingAddressErrors(shippingAddressErrors)
      setBillingAddressErrors(billingAddressErrors)
      return false
    }

    await actions.updateCheckout({
      email,
      paymentMethodId,
      shippingMethodId,
      billingAddress,
      shippingAddress,
      checkoutId,
    })

    router.push('summary')
  }

  const handleCopyFromShipping = () => {
    if (!copyFromShippingFlag) {
      setBillingAddress({ ...shippingAddress })
      setBillingAddressErrors({})
    }

    setCopyFromShippingFlag(!copyFromShippingFlag)
  }

  return (
    <Container maxWidth="lg">
      <Row>
        <Typography variant="h6">Checkout </Typography>
      </Row>
      <Row>
        <Grid container spacing={4}>
          <Grid item xs={12} sm={8}>
            <Vbox style={{ margin: 20 }}>
              <Card style={{ width: '100%' }}>
                <CardHeader title="Shipping Details" />

                <CardContent>
                  <RadioGroup aria-label="gender" name="gender1">
                    <FormControlLabel
                      value="female"
                      control={<Radio checked={true} />}
                      label={'Curier'}
                    />
                  </RadioGroup>

                  <AddressInput
                    address={shippingAddress}
                    setAddress={setShippingAddress}
                    errors={shippingAddressErrors}
                    setAddressErrors={setShippingAddressErrors}
                    includeEmail={true}
                    email={email}
                    setEmail={setEmail}
                  />
                </CardContent>
              </Card>
            </Vbox>

            <Vbox style={{ margin: 20 }}>
              <Card style={{ width: '100%' }}>
                <CardHeader title="Billing Details" />
                <CardContent>
                  <FormGroup aria-label="position" row>
                    <FormControlLabel
                      value="{copyFromShippingFlag}"
                      control={<Checkbox color="primary" />}
                      label="Copy from shipping"
                      onClick={handleCopyFromShipping}
                      labelPlacement="start"
                    />
                  </FormGroup>

                  <AddressInput
                    address={billingAddress}
                    setAddress={setBillingAddress}
                    errors={billingAddressErrors}
                    setAddressErrors={setBillingAddressErrors}
                    includeEmail={false}
                  />
                </CardContent>
              </Card>
            </Vbox>

            <Vbox style={{ margin: 20 }}>
              <Card style={{ width: '100%' }}>
                <CardHeader title="Payment method" />
                <CardContent>
                  <PaymentDetails
                    methods={availablePaymentMethods}
                    selectedMethodId={paymentMethodId}
                    setPaymentMethodId={setShippingMethodId}
                  />
                </CardContent>
              </Card>
            </Vbox>
          </Grid>

          <Grid item xs={12} sm={4}>
            <div className={classes.checkoutPanel}>
              <Hbox alignItems="flex-start">
                <div>
                  <Typography variant="subtitle2" className={classes.total}>
                    Estimated Total
                  </Typography>
                  <Typography variant="caption">Tax calculated in checkout</Typography>
                </div>
                <Spacer />
                {/*<Typography variant="subtitle2" className={classes.total}>*/}
                {/*  {price(*/}
                {/*    items.reduce((a, b) => a + b.quantity * parseFloat(b.price), 0),*/}
                {/*    { currency: get(session, 'currency') }*/}
                {/*  )}*/}
                {/*</Typography>*/}
              </Hbox>
              <Hidden xsDown implementation="css">
                <Row>
                  <Divider />
                </Row>
              </Hidden>
              {items.length === 0 ? null : (
                <Link href="/checkout">
                  <Button
                    color="primary"
                    variant="contained"
                    className={clsx(classes.checkoutButton, classes.docked)}
                  >
                    Checkout
                  </Button>
                </Link>
              )}
            </div>
          </Grid>
        </Grid>
      </Row>
      <Button onClick={validateInputFields}>Continue</Button>
    </Container>
  )
}
