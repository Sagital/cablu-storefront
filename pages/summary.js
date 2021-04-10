import React, { useContext } from 'react'
import {
  Button,
  Card,
  CardContent,
  CardHeader,
  Container,
  Divider,
  Grid,
  Typography,
} from '@material-ui/core'
import Row from 'react-storefront/Row'
import SessionContext from '../context/SessionContext'
import AddressCard from '../components/checkout/AddressCard'

export default function Summary() {
  const { session, actions } = useContext(SessionContext)
  //const checkoutId = get(session, 'cart.id')
  // TODO payment method id may not be present because we can't get it from checkout

  const completeCheckout = async () => {
    const paymentMethodId = session.availablePaymentMethods[0].id

    const order = await actions.completeCheckout({
      checkoutId: session.cart.id,
      totalPrice: session.totalPrice.gross,
      paymentMethodId,
    })
  }

  return (
    <Container maxWidth="lg">
      <Row>
        <Typography variant="h6">Checkout Summary</Typography>
      </Row>
      <Row>
        <Grid container spacing={4}>
          <Grid item xs={12} sm={4}>
            <Card style={{ width: '100%' }}>
              <CardHeader title="Shipping Details" />
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  Curier
                </Typography>

                {session.loading ? null : <AddressCard address={session.shippingAddress} />}
              </CardContent>
            </Card>
          </Grid>

          <Grid item xs={12} sm={4}>
            <Card style={{ width: '100%' }}>
              <CardHeader title="Billing Details" />

              <CardContent>
                <Typography variant="h6" gutterBottom>
                  Persoană fizică
                </Typography>
                {session.loading ? null : <AddressCard address={session.billingAddress} />}
              </CardContent>
            </Card>
          </Grid>

          <Grid item xs={12} sm={4}>
            <Card style={{ width: '100%' }}>
              <CardHeader title="Payment Method" />

              <CardContent>
                <Typography variant="h6" gutterBottom>
                  Ramburs
                </Typography>
              </CardContent>
            </Card>
          </Grid>
        </Grid>
      </Row>

      <Row>
        <Grid container spacing={4}>
          {session.loading ? null : (
            <Card style={{ width: '100%' }}>
              <CardHeader title="Comandă" />

              <CardContent>
                <Typography>
                  {session.cart.items.map(item => item.quantity + ' x ' + item.name)}
                </Typography>
                <Divider />
                <Typography> Shipping Price: {session.shippingPrice.gross}</Typography>
                <Typography> Total Price: {session.totalPrice.gross}</Typography>
              </CardContent>
            </Card>
          )}
        </Grid>
      </Row>

      <Button onClick={completeCheckout}>Finalizare comandă</Button>
    </Container>
  )
}
