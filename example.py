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

I am writing to confirm my upcoming business trip from 9 Sep to 15 Sep (fly from Singapore to London on 9 Sep, take the train from London to Paris on 12 Sep evening). The purpose of this trip is to meet with the GMQR Lab team in London and Paris and discuss the progress of ongoing projects.

Specifically, I am looking forward to meeting with Francois, Marouane, and Ashraf in Paris to discuss our FXO & EQD pairs market move prediction project. I am aware of Francois' expertise in implementing trading projects using SharpeNet, and I believe that this tool will be beneficial in this project. Additionally, Marouane and Ashraf's experience in analyzing the impact of clients' trading on market move will provide valuable insights. I am excited to exchange ideas and best practices with the team members and gather feedback on our work.

In London, I will be meeting with Guoyang to discuss our JGB auction project. Guoyang has experience in doing bond auction projects in the Europe region, and I believe that our discussion will be beneficial in identifying potentially relevant ideas for the JGB auction project.

Finally, I am looking forward to meeting with Julien in London. Julien is knowledgeable in the domain of NLP, and I believe that his expertise will be beneficial for my backup support role in the E2T project.

Thank you for your understanding and support. I am confident that this face-to-face interaction will be incredibly beneficial in understanding various projects and tools implemented by the team, helping to facilitate future projects, and enhancing our collaborations.

Best regards,
Jiang Yu
