1) So the session cart starts in the PendingLoansController in the create action. The params I had for the pivot were "id" and "loan_amount"
2) so first thing we do is update the cart:
  a) if there is a cart already (if session[:cart], then update cart)
  b) else we set the session cart by doing session[:cart] = { id => cart_amount }.

3) our update action in the pending_loans controller takes each {id => loan_amount} pair and creates a pending_loans instance variable
hash out of it. We put in the has an object and the loan amount so that way we can render these objects on the cart_show page.
