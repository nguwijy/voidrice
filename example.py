import torch
use_correct = True

nrow = 1
X = torch.rand((nrow, 3), requires_grad=True)
bid = 2 * X.square().sum(axis=1)

if use_correct:
    state = torch.zeros((nrow, 3), requires_grad=True)
    next_state = state.clone()
    next_state[:, 0] += bid
else:
    next_state = torch.tensor([[0, bid[0], 1]], requires_grad=True)


y = torch.rand((nrow, 3), requires_grad=True)
yy = y.clone()  # removing this line & do `y[0, : ] += ...` yields an error!
yy[0, :] += next_state.sum(axis=0)

torch.autograd.backward(yy.sum())
print(X.grad)
print(4 * X)
