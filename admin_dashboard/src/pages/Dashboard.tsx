import React from 'react';

export function Dashboard() {
  const stats = [
    { name: 'Total Users', value: '1,234', change: '+12%' },
    { name: 'Active Workers', value: '856', change: '+8%' },
    { name: 'Jobs Posted', value: '456', change: '+15%' },
    { name: 'Total Revenue', value: 'P 125,000', change: '+20%' },
  ];

  return (
    <div>
      <h1 className="text-2xl font-bold text-gray-800 mb-6">Dashboard</h1>
      
      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        {stats.map((stat) => (
          <div key={stat.name} className="bg-white p-6 rounded-lg shadow">
            <p className="text-sm text-gray-600">{stat.name}</p>
            <p className="text-2xl font-bold text-gray-800">{stat.value}</p>
            <p className="text-sm text-green-600">{stat.change} from last month</p>
          </div>
        ))}
      </div>

      {/* Recent Activity */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-lg font-semibold text-gray-800 mb-4">Recent Activity</h2>
        <div className="space-y-4">
          <div className="flex items-center justify-between py-2 border-b">
            <div>
              <p className="font-medium">New user registered</p>
              <p className="text-sm text-gray-600">John Doe joined as a worker</p>
            </div>
            <span className="text-sm text-gray-500">2 hours ago</span>
          </div>
          <div className="flex items-center justify-between py-2 border-b">
            <div>
              <p className="font-medium">Job completed</p>
              <p className="text-sm text-gray-600">Plumbing job in Gaborone</p>
            </div>
            <span className="text-sm text-gray-500">4 hours ago</span>
          </div>
          <div className="flex items-center justify-between py-2">
            <div>
              <p className="font-medium">Payment received</p>
              <p className="text-sm text-gray-600">P 500 from customer</p>
            </div>
            <span className="text-sm text-gray-500">6 hours ago</span>
          </div>
        </div>
      </div>
    </div>
  );
}