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


from scipy.stats import norm
import numpy as np
import matplotlib.pyplot as plt

def plt_indicator_func_with_gaussian(sig):
    x = np.linspace(-4, 4, 1000)
    y = 1 - norm.cdf(-x/sig)
    plt.plot(x, y)
    plt.show()

plt_indicator_func_with_gaussian(.1)
plt_indicator_func_with_gaussian(1)





Dear Arnaud,

As previously discussed, I plan to do a business trip from 9 Sep to 15 Sep (fly from Singapore to London on 9 Sep, take the train from London to Paris on 12 Sep evening).

The primary purpose of this business trip is to meet with the GMQR Lab team in London and Paris, whom I have not yet had the opportunity to meet in person. The face-to-face interaction will be incredibly beneficial in understanding various projects and tools implemented by the team, helping to facilitate future projects and enhance our collaborations.

During my trip, I will also present the latest updates on our existing projects to the team and gather feedback on our work. I look forward to exchanging ideas and best practices with the team members.

Thank you for your understanding and support.

Best regards,
[Your name]



Subject: Business Trip from 9 September to 15 September

How do you think about the following email?

Dear Arnaud,

As previously discussed, I plan to do a business trip from 9 Sep to 15 Sep (fly from Singapore to London on 9 Sep, take the train from London to Paris on 12 Sep evening).

The primary purpose of this business trip is to meet with the GMQR Lab team in London and Paris, whom I have not yet had the opportunity to meet in person. The face-to-face interaction will be incredibly beneficial in understanding various projects and tools implemented by the team, helping to facilitate future projects and enhance our collaborations.

During my trip, I will also present the latest updates on our existing projects to the team and gather feedback on our work. I am also looking forward to exchanging ideas and best practices with the team members.

Thank you for your understanding and support. I look forward to updating you on my trip when I return.

Best regards,
[Your name]
